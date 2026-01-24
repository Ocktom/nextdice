extends Node

var game_state : Enums.GameState

var audio_node : Node
var grid : Node
var world: Node

var player_dice : Array

var all_cards : Array [Card]
var game_speed := 1

var starting_enemy_count := 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	await timer(.01)
	for x in starting_enemy_count:
		var card_path : PackedScene = preload("res://Systems/Card_System/Card.tscn")
		var cell_pick = Global.grid.get_empty_cells().pick_random()
		var card_inst = card_path.instantiate()
		cell_pick.spawn_card(card_inst)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
	await timer(.2)

func animate(node: Node, anim : Enums.Anim, flash_color = Color.WHITE):
	
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
