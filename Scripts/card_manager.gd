extends Node

var card_data_dictionary : Dictionary
var basic_card_names : Array

func _ready() -> void:
	
	pass
	#var card_data_script = load("res://Scripts/card_data_dictionary.gd").new()
	#card_data_dictionary = card_data_script.data
	
func deal_card_to_cell(name_string : String, cell : Cell):
	
	print ("dealing card ", name_string)
	
	var card_path : PackedScene = preload("res://Systems/Card_System/Card.tscn")
	var new_card = card_path.instantiate()
	
	new_card.card_name = name_string
	
	Global.main_scene.card_layer.add_child(new_card)
	
	await cell.fill_with_card(new_card)
	await Global.animate(new_card,Enums.Anim.POP)
	
func fill_card_from_data(card: Card, name_string: String):
	
	var data = Cards.card_data_dictionary[name_string]

	# Base value
	
	card.base_value = data["base_value"]
	card.card_value = card.base_value
	card.card_type = data["card_type"]
	
	card.destroy_effect_1 = data["destroy_effect_1"]
	card.destroy_effect_1_type = data["destroy_effect_1_type"]
	#card.destroy_effect_1_int = data["destroy_effect_1_int"]
	
	card.destroy_effect_2 = data["destroy_effect_2"]
	card.destroy_effect_2_type = data["destroy_effect_2_type"]
	#card.destroy_effect_2_int = data["destroy_effect_2_int"]
	
	card.passive_effect_1 = data["passive_effect_1"]
	card.passive_effect_2 = data["passive_effect_2"]
	
	card.passive_effects = [card.passive_effect_1, card.passive_effect_2]
	
	await card.update_visual()
