extends Control
class_name Reward_Screen

@onready var item_container: HBoxContainer = $Item_Container
@onready var skip_button: Button = $Bottom_Buttons/Skip_Button
@onready var reroll_button: Button = $Bottom_Buttons/Reroll_Button

var current_items : Array

var reroll_cost := 1

func _ready() -> void:
	
	skip_button.connect("pressed",_on_skip_pressed)
	reroll_button.connect("pressed",_on_reroll_pressed)

func get_new_rewards(reward_type: Enums.ItemType):
	
	var item_path : PackedScene
	
	match reward_type:
		
		Enums.ItemType.GEAR:
	
			item_path = preload("res://Systems/Item System/Gear_Item.tscn")
	
	for x in 3:
		print ("instantiating reward of item_tpye", reward_type)
		var inst = item_path.instantiate()
		item_container.add_child(inst)
	
func _on_skip_pressed():
	Global.game_state = Enums.GameState.PLAYER_TURN
	queue_free()

func _on_reroll_pressed():
	
	if Global.player_stats.gold < reroll_cost:
		Global.float_text("NOT ENOUGH GOLD",reroll_button.global_position,Color.GOLD)
		return
	
	Global.float_text(str("- $",reroll_cost),reroll_button.global_position,Color.GOLD)
	Global.player_stats.gold -= reroll_cost
	Global.player_ui.update()
	
	for child in item_container.get_children():
		child.queue_free()
		
	await get_new_rewards(Enums.ItemType.GEAR)
	
	reroll_cost += 1
	
	reroll_button.text = str("REROLL - $", reroll_cost)
