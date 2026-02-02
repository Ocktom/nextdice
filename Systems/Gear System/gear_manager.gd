extends Node

var gear_data_dictionary : Dictionary
var gear_names = gear_data_dictionary.keys()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var gear_data_script = load("res://Systems/Gear System/gear_data_dictionary.gd").new()
	gear_data_dictionary = gear_data_script.data
	gear_names = gear_data_dictionary.keys()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func insert_gear(gear_name : String, dice_face: Face):
	print("inserting gear")
	var gear_data = gear_data_dictionary[gear_name]
	dice_face.gear[gear_name] = gear_data
	
