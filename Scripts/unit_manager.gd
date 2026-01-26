extends Node

var enemy_data_dictionary : Dictionary
var enemy_data
var starting_enemy_count := 4
var enemy_names : Array

func _ready() -> void:
	
	var unit_data_script = load("res://Systems/Unit_System/enemy_data_dictionary.gd").new()
	enemy_data_dictionary = unit_data_script.data
	enemy_names = enemy_data_dictionary.keys()
	
func deal_unit_to_cell(name_string : String, cell : Cell):
	
	print ("dealing unit ", name_string)
	
	var unit_path : PackedScene = preload("res://Systems/Unit_System/Unit.tscn")
	var new_unit = unit_path.instantiate()
	
	Global.main_scene.unit_layer.add_child(new_unit)
	
	await cell.fill_with_unit(new_unit)
	await Global.animate(new_unit,Enums.Anim.POP)
	
func spawn_new_enemy(name_string: String, cell : Cell):
	
	#PRERPARE NEW UNIT TO BE FILLED WITH DATA
	
	var unit_path = preload("res://Systems/Unit_System/Unit_Enemy.tscn")
	var unit = unit_path.instantiate()
	
	#ALL DATA FILL FROM DICTIONARY GOES HERE
	
	var data = enemy_data_dictionary[name_string]
	unit.unit_name = name_string
	unit.hp = data["hp"]
	unit.max_hp = unit.hp
	unit.atk = data["atk"]
	unit.atk_range = data["atk_range"]
	unit.movement = data["movement"]
	unit.range_type = data["range_type"]

	unit.action_1 = data["action_1"]
	unit.action_2 = data["action_2"]
	
	#APPLY ROUND DIFFICULTY STATS
	
	if Global.round_number > 1: 
		unit.atk += Global.round_number
		unit.hp += Global.round_number * 2
	
	var sprite_path = str("res://Art/Enemy_Sprites/", name_string, ".png")
	#SPAWN PREPARED UNIT INTO CELL
	
	await cell.fill_with_unit(unit)
	Global.world.unit_layer.add_child(unit)
	unit.unit_sprite.texture = load(sprite_path)
	
