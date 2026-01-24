extends Node

var unit_data_dictionary : Dictionary
var basic_unit_names : Array

func _ready() -> void:
	
	pass
	#var unit_data_script = load("res://Scripts/unit_data_dictionary.gd").new()
	#unit_data_dictionary = unit_data_script.data
	
func deal_unit_to_cell(name_string : String, cell : Cell):
	
	print ("dealing unit ", name_string)
	
	var unit_path : PackedScene = preload("res://Systems/Unit_System/Unit.tscn")
	var new_unit = unit_path.instantiate()
	
	new_unit.unit_name = name_string
	
	Global.main_scene.unit_layer.add_child(new_unit)
	
	await cell.fill_with_unit(new_unit)
	await Global.animate(new_unit,Enums.Anim.POP)
	
func fill_unit_from_data(unit: Unit, name_string: String):
	
	var data = Units.unit_data_dictionary[name_string]
	
	
	unit.passive_effects = [unit.passive_effect_1, unit.passive_effect_2]
	
	await unit.update_visual()
