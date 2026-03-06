extends Node

var gear_data_dictionary : Dictionary
var skill_data_dictionary : Dictionary
var enemy_data_dictionary : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var gear_data_script = load("res://Systems/Inventory/gear_data_dictionary.gd").new()
	gear_data_dictionary = gear_data_script.data
	
	var skill_data_script = load("res://Systems/Skill_System/skill_data_dictionary.gd").new()
	skill_data_dictionary = skill_data_script.data
	
	var unit_data_script = load("res://Systems/Unit_System/enemy_data_dictionary.gd").new()
	enemy_data_dictionary = unit_data_script.data

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
