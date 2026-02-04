extends Node

var game_state : Enums.GameState

var audio_node : Node
var grid : Node
var world: Node
var hero_unit : Unit

var round_number := 1

var player_ui: Control
var player_dice : Array

var all_units : Array [Unit]
var game_speed := 1

var starting_enemy_count := 3

var relics : Array[Item]

var mana := 0
var max_mana := 10
var max_hp := 10
var player_hp := 10

var player_status_effects : Dictionary = {}

var max_rolls := 3
var rolls := 3

var current_sum := 0

func timer(time : float):

	time = (time/game_speed)
	await get_tree().create_timer(time).timeout

func float_text(message: String, position: Vector2, color := Color.WHITE):
	
	print ("Float text")
	
	var text_scene = preload("res://Systems/Float_Text/Float_Text.tscn")
	var floating_text = text_scene.instantiate()
	get_tree().current_scene.add_child(floating_text)
	floating_text.global_position = position
	floating_text.show_text(message, color)
	await timer(.4)

func animate(node: Node, anim : Enums.Anim, flash_color = Color.WHITE, target_node: Node = null):
	
	print ("animating...")
	
	var tween = node.create_tween()
	
	match anim:
		
		Enums.Anim.FLASH:

			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_SINE)
			var original_modulate = Color(1,1,1,1)
			var bright_flash = flash_color * 1.5
			bright_flash.a = 1.0
			tween.tween_property(node, "modulate", bright_flash, 0.1)
			tween.tween_property(node, "modulate", original_modulate, 0.1)
		
		Enums.Anim.SHAKE:

			var original = node.position
			var strength = 7          # how far up/down it moves
			var shakes = 4             # number of up/down motions
			var duration = 0.25        # total shake time

			tween.set_trans(Tween.TRANS_SINE)
			tween.set_ease(Tween.EASE_IN_OUT)

			for i in range(shakes):
				# Alternate up/down
				var direction = 1 if i % 2 == 0 else -1
				var offset = Vector2(0, strength * direction)
				tween.tween_property(node, "position", original + offset, duration / shakes)

			# Return to original position
			tween.tween_property(node, "position", original, 0.1)

		Enums.Anim.POP:
			
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_BACK)
			var original_scale = Vector2(1,1)
			var pop_scale = original_scale * 1.15
			tween.tween_property(node, "scale", pop_scale, 0.1)
			tween.tween_property(node, "scale", original_scale, 0.15)
		
		Enums.Anim.SQUISH:
	
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_BACK)
			var original_scale = Vector2(1,1)
			var squish_scale = original_scale * 0.85
			tween.tween_property(node, "scale", squish_scale, 0.1)
			tween.tween_property(self, "scale", original_scale, 0.15)
		
		Enums.Anim.DART:

			if target_node == null:
				return

			var original = node.position
			var distance = 16
			var duration_out = 0.06
			var duration_back = 0.08

			# Direction in global space
			var dir = (target_node.global_position - node.global_position).normalized()

			# Convert to local-space offset
			var offset = dir * distance

			tween.set_trans(Tween.TRANS_SINE)
			tween.set_ease(Tween.EASE_OUT)

			tween.tween_property(
				node,
				"position",
				original + offset,
				duration_out
			)

			tween.set_ease(Tween.EASE_IN)

			tween.tween_property(
				node,
				"position",
				original,
				duration_back
			)
	
		Enums.Anim.LUNGE:

			if target_node == null:
				return

			var original = node.global_position
			var target = target_node.global_position

			var duration_out = 0.12
			var duration_back = 0.12

			tween.set_trans(Tween.TRANS_SINE)
			tween.set_ease(Tween.EASE_OUT)

			tween.tween_property(
				node,
				"global_position",
				target,
				duration_out
			)

			tween.set_ease(Tween.EASE_IN)

			tween.tween_property(
				node,
				"global_position",
				original,
				duration_back
			)

	
func get_path_cells(start_cell : Cell, target_cell : Cell, max_move : int) -> Array[Cell]:
	
	var path : Array[Cell] = []
	var current_pos = start_cell.cell_vector
	var target_pos = target_cell.cell_vector

	var remaining = max_move

	while remaining > 0 and current_pos != target_pos:
		
		var dx = target_pos.x - current_pos.x
		var dy = target_pos.y - current_pos.y

		var step = Vector2i(
			sign(dx),
			sign(dy)
		)

		current_pos += step

		if not Global.grid.is_in_bounds(current_pos):
			break

		path.append(Global.grid.grid[current_pos.x][current_pos.y])
		remaining -= 1

	return path

func unhighlight_cells():
	for x in grid.all_cells:
		x.highlight = false
