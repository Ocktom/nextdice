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
	
	
	card.passive_effects = [card.passive_effect_1, card.passive_effect_2]
	
	await card.update_visual()
