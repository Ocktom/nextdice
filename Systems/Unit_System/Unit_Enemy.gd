extends Unit
class_name Enemy

@onready var unit_sprite: AnimatedSprite2D = $Unit_Sprite
@onready var hp_label: Label = $Right_Stats/HBoxContainer/HP_Label
@onready var shield_label: Label = $Right_Stats/HBoxContainer/SHIELD_Label
@onready var atk_label: Label = $Right_Stats/ATK_Label
@onready var sprite_ov: Sprite2D = $Sprite_OV

var hp : int
var max_hp : int
var poison : int
var burn : int
var stun : bool
var forcefield : bool
var shield : int
var invisible : int

var atk := 1
var atk_range := 1

var frozen := false

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

func get_attack_targets() -> Array[Unit]:
	var targets : Array[Unit] = []

	for cell in get_attack_cells():
		if cell.occupant == null:
			continue

		if cell.occupant is Torch:
			targets.append(cell.occupant)
		
		if cell.occupant is Hero:
			targets.append(cell.occupant)
		
	return targets

func plan_action():

	if status_effects.has("stun"):
		Global.float_text("stunned",global_position)
		return
	
	if status_effects.has("freeze"):
		Global.float_text("FROZEN",global_position,Color.AQUA)
		return
	
	if status_effects.has("root"):
		Global.float_text("rooted",global_position)
	
	if await attempt_attack():
		await enemy_actions()
		return

	elif await attempt_move():
		Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNMisc_HIT-Zap Metal_HY_PC-002.wav")
		await enemy_actions()
		return
	
	else:
		await enemy_actions()
	
func attempt_attack():
	
	if atk < 1:
		return null
	
	var targets = get_attack_targets()

	if targets.is_empty():
		return null

	# Pick ONE target at random
	var target : Unit = targets.pick_random()

	print("enemy ", unit_name, " attacking ", target.unit_name)

	await Global.timer(wait_time)
	await ActionManager.request_action(
		"attack",
		{
			"amount": atk
		},
		self.current_cell,
		target.current_cell
	)
	
	turn_bonus = 0
	await enemy_actions(target)

	return target

func attempt_move() -> bool:
	
	if status_effects.has("root"):
		return false
	
	if movement < 1:
		return false
	
	var hero_cell = Global.hero_unit.current_cell
	var my_cell = current_cell

	var dx = abs(hero_cell.cell_vector.x - my_cell.cell_vector.x)
	var dy = abs(hero_cell.cell_vector.y - my_cell.cell_vector.y)

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
	var best_distance = max(dx, dy)

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
				return true

			if dist < best_distance:
				best_distance = dist
				best_path = path.duplicate()

	if best_path.size() == 0:
		return false

	print("enemy ", self, " moving")
	await Global.timer(wait_time)
	for c in best_path:
		await current_cell.clear_cell()
		await c.fill_with_unit(self)
		await Global.timer(step_time)

	return true
	
func enemy_actions(attack_target: Node2D = null):
	var target_cell: Cell
	
	if attack_target == null:
		target_cell = null
	else:
		target_cell = attack_target.current_cell
	
	if action_1_name == "transform_unit":
		if status_effects.keys().has("regrowing"):
			if status_effects["regrowing"] > 0:
				return
				
		target_cell = current_cell
	
	if action_1_name == "spawn_unit":
		target_cell = Global.grid.get_empty_cells().pick_random()
		
	if action_1_name != "":
		await ActionManager.request_action(action_1_name, action_1_context, current_cell, target_cell)
	
	if action_2_name != "":
		await ActionManager.request_action(action_2_name, action_2_context, current_cell, target_cell)

func take_attack(amount : int, attacker: Unit):
	
	await ActionManager.request_action("damage_unit",{"amount" : amount, "damage_name" : "physical"},attacker.current_cell,current_cell)
	
	
func take_damage(amount : int):
	
	print ("was damaged")
	Global.animate(self,Enums.Anim.SHAKE)
	await Global.animate(self,Enums.Anim.FLASH,Color.RED)
	await Global.timer(.5)
	
	hp = max(0,hp-amount)
	
	if hp < 1:
		
		print ("unit has less then 1 hp, calling enemy death on manager")
		dying_this_turn = true
		ActionManager.request_action("enemy_death",{},current_cell)
	
	if not dying_this_turn:
		await update()
	
func end_turn_effects():
	
	print ("end_turn effects for ", unit_name)
	
	await StatusManager.end_turn_effects(self)
	if not dying_this_turn:
		await update()
		
func update():
	
	hp_label.text = str(hp)
	atk_label.text = str(atk)
	
	await StatusManager.update_status_effects(self)
