extends Unit
class_name Enemy

var hp : int

var max_hp : int

var atk := 1
var atk_range := 1

var dying_this_turn := false

var move_diag := false

var attack_diag : bool
var attack_cardinal : bool

var turn_bonus := 0
var round_bonus := 0

var action_1_name : String
var action_1_context : Dictionary

var passive_1_name : String
var passive_1 : Passive
var passive_1_trigger : Enums.Trigger

var passive_2_name : String
var passive_2 : Passive

var action_2_name : String
var action_2_context : Dictionary


var projectile := false
var movement := 2

var wait_time := .2
var step_time := .1

var acted_this_turn := false

func set_passives():
	
	if not passive_1_name == "":
		passive_1 = Passive.new()
		var script_path = str("res://Systems/Passive_System/Passive_Scripts/passive_",passive_1_name,".gd")
		print ("setting passive script_path for ", script_path)
		passive_1.set_script(load(script_path))
		passive_1.passive_name = passive_1_name
		print ("passive_1 is ", passive_1, " with name of ", passive_1.passive_name)
		passive_1.source = self
		passive_1.set_trigger()
		
	if not passive_2_name == "":
		passive_2 = Passive.new()
		var script_path = str("res://Systems/Passive_System/Passive_Scripts/",passive_2_name,".gd")
		passive_2.set_script(load(script_path))
		passive_1.source = self
		passive_2.set_trigger()

func get_attack_cells() -> Array[Cell]:
	
	print (unit_name, " getting attack cells, attack_diag is", attack_diag, " and attack_caridnal is ", attack_cardinal)
	
	var cells : Array[Cell] = []
	var origin = current_cell.cell_vector

	var directions = []

	if attack_cardinal:
		directions.append(Vector2i(0, -1))
		directions.append(Vector2i(0, 1))
		directions.append(Vector2i(-1, 0))
		directions.append(Vector2i(1, 0))

	if attack_diag:
		directions.append(Vector2i(-1, -1))
		directions.append(Vector2i(1, -1))
		directions.append(Vector2i(-1, 1))
		directions.append(Vector2i(1, 1))

	for dir in directions:
		for i in range(1, atk_range + 1):
			var p = origin + dir * i

			if not Global.grid.is_in_bounds(p):
				break

			var cell = Global.grid.grid[p.x][p.y]
			cells.append(cell)

			# LOS BLOCKER
			if not cell.is_empty():
				break

	return cells

func plan_action():
	
	print("enemy planning action")

	var hero = Global.hero_unit
	var hero_cell = hero.current_cell
	var my_cell = current_cell

	var dx = hero_cell.cell_vector.x - my_cell.cell_vector.x
	var dy = hero_cell.cell_vector.y - my_cell.cell_vector.y

	var abs_dx = abs(dx)
	var abs_dy = abs(dy)

# ---------------- ATTACK CHECK ----------------


	var attack_cells = get_attack_cells()

	if attack_cells.has(hero_cell):
		print("enemy ", self, " attacking")
		await Global.timer(wait_time)
		await ActionManager.request_action(
			"attack",
			{"target" : hero, "amount" : atk},
			self
		)
		turn_bonus = 0
		await enemy_actions()
		return


	# ---------------- MOVEMENT ----------------

	var directions = [
		Vector2i(0, -1),
		Vector2i(0, 1),
		Vector2i(-1, 0),
		Vector2i(1, 0),
		Vector2i(-1, -1),
		Vector2i(1, -1),
		Vector2i(-1, 1),
		Vector2i(1, 1)
	]

	var best_path = []
	var best_distance = max(abs_dx, abs_dy)

	for dir in directions:
		var step_cell = my_cell
		var path = []
		var remaining = movement

		while remaining > 0:
			var next_pos = step_cell.cell_vector + dir

			if not Global.grid.is_in_bounds(next_pos):
				break

			var next_cell = Global.grid.grid[next_pos.x][next_pos.y]
			if not next_cell.is_empty():
				break

			step_cell = next_cell
			path.append(step_cell)
			remaining -= 1

			var dist = max(
				abs(hero_cell.cell_vector.x - step_cell.cell_vector.x),
				abs(hero_cell.cell_vector.y - step_cell.cell_vector.y)
			)

			if dist == 1:
				print("enemy ", self, " moving")
				await Global.timer(wait_time)
				for c in path:
					await current_cell.clear_cell()
					c.fill_with_unit(self)
					await Global.timer(step_time)
				return

			if dist < best_distance:
				best_distance = dist
				best_path = path.duplicate()

	# ---------------- EXECUTE MOVE ----------------

	if best_path.size() > 0:
		await Global.timer(wait_time)
		print("enemy ", self, " moving")
		for c in best_path:
			await current_cell.clear_cell()
			c.fill_with_unit(self)
	
	await enemy_actions()
	
func enemy_actions():
	
	if action_1_name != "":
		await ActionManager.request_action(action_1_name, action_1_context, self)
	
	if action_2_name != "":
		await ActionManager.request_action(action_1_name, action_2_context, self)

func take_attack(amount : int):
	
	hp = max(0,hp-amount)
	
	if hp < 1:
		dying_this_turn = true
	
	print ("was damaged")
	Global.animate(self,Enums.Anim.SHAKE)
	await Global.animate(self,Enums.Anim.FLASH,Color.RED)
	await Global.float_text("Damage",global_position,Color.RED)
	await Global.timer(.5)
	
	if dying_this_turn:
		print ("unit has less then 1 hp, calling enemy death on manager")
		ActionManager.request_action("enemy_death",{},self)
	
	update()
	
func take_non_attack_damage(amount : int):
	
	print ("was damaged")
	Global.animate(self,Enums.Anim.SHAKE)
	await Global.animate(self,Enums.Anim.FLASH,Color.RED)
	await Global.float_text("Damage",global_position,Color.RED)
	await Global.timer(.5)
	
	hp = max(0,hp-amount)
	
	if hp < 1:
		
		print ("unit has less then 1 hp, calling enemy death on manager")
		ActionManager.request_action("enemy_death",{},self)
	
	update()

func update():
	
	unit_name_label.text = str(unit_name)
	hp_label.text = str(hp)
	atk_label.text = str(atk)
