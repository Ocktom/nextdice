extends Control
class_name Reward_Screen

@onready var item_container: HBoxContainer = $Item_Container
@onready var skip_button: Button = $Skip_Button

func _ready() -> void:
	skip_button.connect("pressed",_on_skip_pressed)

func get_new_rewards():
	
	var item_path : PackedScene = preload("res://Systems/Item System/Item_Replace_Skill.tscn")
	
	for x in 3:
		var inst = item_path.instantiate()
		item_container.add_child(inst)
		inst.pick_random_skills()

func _on_skip_pressed():
	Global.game_state = Enums.GameState.PLAYER_TURN
	queue_free()
