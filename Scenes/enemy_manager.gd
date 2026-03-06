extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.enemy_manager = self

func get_attack_cells(acting_enemy: Enemy) -> Array[Cell]:
	
	print (acting_enemy.unit_name, " getting attack cells, attack_diag is", acting_enemy.attack_diag, " and attack_caridnal is ", acting_enemy.attack_cardinal)
	
	var cells : Array[Cell] = []
	var origin = acting_enemy.current_cell.cell_vector

	var directions = []

	if acting_enemy.attack_cardinal:
		directions.append(Vector2i(0, -1))
		directions.append(Vector2i(0, 1))
		directions.append(Vector2i(-1, 0))
		directions.append(Vector2i(1, 0))

	if acting_enemy.attack_diag:
		directions.append(Vector2i(-1, -1))
		directions.append(Vector2i(1, -1))
		directions.append(Vector2i(-1, 1))
		directions.append(Vector2i(1, 1))

	for dir in directions:
		for i in range(1, acting_enemy.atk_range + 1):
			var p = origin + dir * i

			if not Global.grid.is_in_bounds(p):
				break

			var cell = Global.grid.grid[p.x][p.y]
			cells.append(cell)

			# LOS BLOCKER
			if not cell.is_empty():
				break

	return cells

func get_attack_targets(acting_enemy: Enemy) -> Array[Unit]:
	
	var targets : Array[Unit] = []

	for cell in get_attack_cells(acting_enemy):
		if cell.occupant == null:
			continue

		if cell.occupant is Torch:
			targets.append(cell.occupant)
		
		if cell.occupant is Hero:
			targets.append(cell.occupant)
		
	return targets

func plan_action(acting_enemy: Enemy):
	
	print ("plan+action ran in manager for ", acting_enemy.unit_name)
	
	if acting_enemy.status_effects.has("stun"):
		Global.float_text("stunned", acting_enemy.global_position)
		return
	
	if acting_enemy.status_effects.has("freeze"):
		Global.float_text("FROZEN", acting_enemy.global_position, Color.AQUA)
		return
	
	await enemy_actions(acting_enemy)
	
	#DOUBLE CHECK 
	
	if is_instance_valid(acting_enemy):
		if not acting_enemy.dying_this_turn:
			acting_enemy.global_position = acting_enemy.current_cell.global_position

func attempt_attack(acting_enemy: Enemy) -> bool:
	
	print ("attempt attack ran in manager for ", acting_enemy.unit_name)
	
	var can_attack = Global.grid.has_straight_path(acting_enemy.current_cell, Global.hero_unit.current_cell,acting_enemy.atk_range,acting_enemy.attack_diag,true)
	if can_attack:
		await Global.action_manager.request_action("attack",{"amount" : acting_enemy.atk},acting_enemy.current_cell,Global.hero_unit.current_cell)
		
		await Global.timer(.2)
		
		return true
	else:
		return false
		
func attempt_move(acting_enemy: Enemy) -> bool:
	
	print ("attempt move ran in manager for ", acting_enemy.unit_name)
	
	if acting_enemy.status_effects.has("root"):
		Global.float_text("rooted", acting_enemy.global_position)
		return false
	
	Global.timer(.3)
	Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNMisc_HIT-Zap Metal_HY_PC-002.wav")
	var path : Array = []
	var target_cell : Cell
	
	path = Global.grid.get_path_to_cell(acting_enemy.current_cell,Global.hero_unit.current_cell,acting_enemy.movement,acting_enemy.move_diag)
	
	if path.has(Global.hero_unit.current_cell):
		path.erase(Global.hero_unit.current_cell)
	
	if path.size() > 0:
		target_cell = path[-1]
		print ("unit ", acting_enemy.unit_name, " moving to ", acting_enemy.current_cell, " of position ", acting_enemy.current_cell.cell_vector)
		await Global.action_manager.request_action("move_unit",{},acting_enemy.current_cell,target_cell)
		await Global.timer(.2)
		return true
	
	return false
	
func enemy_actions(acting_enemy: Enemy):
	
	print ("enemy_actions ran in manager for ", acting_enemy.unit_name)
	
	var target_cell : Cell

	var actions_dict = acting_enemy.enemy_actions
	
	print ("actions_dict is ", actions_dict)
	
	for action_name in actions_dict.keys():

		var context = actions_dict[action_name]

		if context == null:
			context = {}

		await Global.action_manager.request_action(
			action_name,
			context,
			acting_enemy.current_cell,
			acting_enemy.current_cell
		)
		
func reveal_movement(enemy: Unit):
	if enemy == null or enemy.current_cell == null:
		return

	var visited = {}
	var queue = []

	queue.append(enemy.current_cell)
	visited[enemy.current_cell] = 0

	var directions = []

	if enemy.move_diag:
		directions = [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1), Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,1), Vector2i(-1,-1)]
	else:
		directions = [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]

	while queue.size() > 0:
		var cell = queue.pop_front()
		var steps = visited[cell]

		if steps >= enemy.movement:
			continue

		for dir in directions:
			var next_pos = cell.cell_vector + dir

			if not Global.grid.is_in_bounds(next_pos):
				continue

			var next_cell = Global.grid.grid[next_pos.x][next_pos.y]

			if visited.has(next_cell):
				continue

			visited[next_cell] = steps + 1
			queue.append(next_cell)

	for cell in visited.keys():
		if cell != enemy.current_cell:
			cell.set_highlight(true, Global.green_highlight)

func reveal_attack_after_movement(enemy: Unit):
	if enemy == null or enemy.current_cell == null:
		return

	var move_visited = {}
	var move_queue = []

	move_queue.append(enemy.current_cell)
	move_visited[enemy.current_cell] = 0

	var move_dirs = []

	if enemy.move_diag:
		move_dirs = [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1), Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,1), Vector2i(-1,-1)]
	else:
		move_dirs = [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]

	# --- First get all movement cells ---
	while move_queue.size() > 0:
		var cell = move_queue.pop_front()
		var steps = move_visited[cell]

		if steps >= enemy.movement:
			continue

		for dir in move_dirs:
			var next_pos = cell.cell_vector + dir

			if not Global.grid.is_in_bounds(next_pos):
				continue

			var next_cell = Global.grid.grid[next_pos.x][next_pos.y]

			if move_visited.has(next_cell):
				continue

			move_visited[next_cell] = steps + 1
			move_queue.append(next_cell)

	# --- Now expand attack range from each movement cell ---
	var attack_dirs = []

	if enemy.attack_diag:
		attack_dirs = [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1), Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,1), Vector2i(-1,-1)]
	else:
		attack_dirs = [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]

	var attack_cells = {}

	for move_cell in move_visited.keys():
		for dir in attack_dirs:
			for i in range(1, enemy.atk_range + 1):
				var pos = move_cell.cell_vector + dir * i

				if not Global.grid.is_in_bounds(pos):
					break

				var atk_cell = Global.grid.grid[pos.x][pos.y]

				if move_visited.has(atk_cell):
					continue

				attack_cells[atk_cell] = true

	for cell in attack_cells.keys():
		cell.set_highlight(true, Global.red_highlight)
