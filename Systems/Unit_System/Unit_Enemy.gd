extends Unit
class_name Enemy

var hp := 5

var atk := 1
var atk_range := 1
var attack_diag := false
var move_diag := false
var projectile := false
var movement := 2

var wait_time := .5
var step_time := .1

var acted_this_turn := false

func plan_action():
	print("enemy planning action")

	var hero = Global.hero_unit
	var hero_cell = hero.current_cell
	var my_cell = current_cell

	var dx = hero_cell.cell_vector.x - my_cell.cell_vector.x
	var dy = hero_cell.cell_vector.y - my_cell.cell_vector.y

	# --- Attack check (no diagonal) ---
	if (
		(dx == 0 and abs(dy) <= atk_range) or
		(dy == 0 and abs(dx) <= atk_range)
	):
		await Global.timer(wait_time)
		print("enemy ", self, " attacking")
		hero.take_attack(atk)
		return

	var start_dist = abs(dx) + abs(dy)
	var best_path = []
	var best_distance = start_dist

	var directions = [
		Vector2i(0, -1),
		Vector2i(0, 1),
		Vector2i(-1, 0),
		Vector2i(1, 0)
	]

	for dir in directions:
		var step_cell = my_cell
		var path = []

		for i in range(movement):
			var next_pos = step_cell.cell_vector + dir

			if not Global.grid.is_in_bounds(next_pos):
				break

			var next_cell = Global.grid.grid[next_pos.x][next_pos.y]

			if not next_cell.is_empty():
				break

			step_cell = next_cell
			path.append(step_cell)

			var dist = abs(hero_cell.cell_vector.x - step_cell.cell_vector.x) \
				+ abs(hero_cell.cell_vector.y - step_cell.cell_vector.y)

			# Prefer adjacency
			if dist == 1:
				await Global.timer(wait_time)
				print("enemy ", self, " moving")

				for c in path:
					await current_cell.clear_cell()
					c.fill_with_unit(self)
					await Global.timer(step_time)

				return

			if dist < best_distance:
				best_distance = dist
				best_path = path.duplicate()

	# --- Execute best path ---
	if best_path.size() > 0:
		await Global.timer(wait_time)
		print("enemy ", self, " moving")

		for c in best_path:
			await current_cell.clear_cell()
			c.fill_with_unit(self)
			await Global.timer(step_time)

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
