extends Node

var backpack_gear : Array[String] = ["Dagger","Dagger","Broadsword"]

var attack_gear : Array[String] = ["Dagger","Broadsword"]
var movement_gear : Array[String] = ["Greaves"]
var magic_gear : Array[String] = ["Magic_Ring"]

var attack_skills : Array[String]
var movement_skills : Array[String]
var magic_skills : Array[String]

var skill_sets := [attack_skills, movement_skills, magic_skills]
var gear_sets := [attack_gear,movement_gear,magic_gear]

var gear_data_dictionary : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var gear_data_script = load("res://Systems/Inventory/gear_data_dictionary.gd").new()
	gear_data_dictionary = gear_data_script.data

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func drop_gear(gear_name: String):
	print ("backpackgear pre-drop is ", backpack_gear)
	print ("dropping gear of ", gear_name)
	var first_inst = backpack_gear.find(gear_name)
	backpack_gear.remove_at(first_inst)
	print ("backpackgear post-drop is ", backpack_gear)
	await Global.back_gear_node.load_backpack_gear()

func update_skills_from_gear():
		for gear_set in gear_sets:
			var ind = gear_sets.find(gear_set)
			skill_sets[ind] = []
			for gear in gear_set:
				var skill_string = GameData.gear_data_dictionary[gear]["skills"]
				var skill_array = parse_string_to_array(skill_string)
				for skill in skill_array:
					skill_sets[ind].append(skill)
		print ("skill_sets after update are ", skill_sets)

func parse_string_to_array(input: String) -> Array:
	var items = input.split(",")
	for i in range(items.size()):
		items[i] = items[i].strip_edges()
	return items
