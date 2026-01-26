extends Unit
class_name Enemy

var hp : int

var max_hp : int

var atk := 1
var atk_range := 1

var move_diag := false
var can_attack_diag := true

var turn_bonus := 0
var round_bonus := 0

var action_1 : String
var action_2 : String

var projectile := false
var movement := 2

var wait_time := .2
var step_time := .1

var acted_this_turn := false

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

	var in_range = false

	# Cardinal attack
	if dx == 0 and abs_dy <= atk_range:
		in_range = true
	elif dy == 0 and abs_dx <= atk_range:
		in_range = true

	# Diagonal attack (optional)
	elif can_attack_diag and abs_dx == abs_dy and abs_dx <= atk_range:
		in_range = true

	if in_range:
		
		print("enemy ", self, " attacking")
		await attack(Global.hero_unit)
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
				await enemy_actions()
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

func attack(target_unit : Unit):
	await Global.timer(wait_time)
	Global.animate(self,Enums.Anim.DART,Color.WHITE,target_unit)
	await target_unit.take_attack(atk + turn_bonus + round_bonus)
	
func enemy_actions():
	
	if action_1 != "":
		await ActionManager.request_action(action_2, {"source " : self})
		
	if action_1 != "":
		await ActionManager.request_action(action_2, {"source " : self})
	
func take_attack(amount : int):
	
	print ("was damaged")
	Global.animate(self,Enums.Anim.SHAKE)
	await Global.animate(self,Enums.Anim.FLASH,Color.RED)
	await Global.float_text("Damage",global_position,Color.RED)
	await Global.timer(.5)
	
	hp = max(0,hp-amount)
	
	if hp < 1:
		
		destroy()
	
	update_visuals()

func destroy(overkill := false):
	
	ActionManager.destroy_enemy(self)

func update_visuals():
	
	unit_name_label.text = str(unit_name)
	hp_label.text = str(hp)
