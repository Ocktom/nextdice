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
	
	print ("spawning enemy with name ", name_string)
	
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
	unit.unit_passives = parse_passives_string(data["unit_passives"])
	unit.range_type = Enums.RangeType[data["range_type"]]
	
	print ("matching unit range_type of ", unit.range_type)
	match unit.range_type:
		
		Enums.RangeType.CARDINAL:
			unit.attack_diag = false
			unit.attack_cardinal = true
		Enums.RangeType.DIAG:
			unit.attack_diag = true
			unit.attack_cardinal = false
		Enums.RangeType.ALL:
			unit.attack_diag = true
			unit.attack_cardinal = true

	unit.action_1_name = data["action_1_name"]
	if not unit.action_1_name == "":
		unit.action_1_context = data["action_1_context"]
		
	if not unit.action_2_name == "":
		unit.action_2_context = data["action_2_context"]
	
	#APPLY ROUND DIFFICULTY STATS
	
	if Global.round_number > 1: 
		unit.hp += Global.round_number
	
	var frames_path = str("res://Art/Enemy_Sprites/sprite_frames/",name_string,"_frames.tres")
	#SPAWN PREPARED UNIT INTO CELL
	Global.world.unit_layer.add_child(unit)
	await cell.fill_with_unit(unit)
	unit.unit_sprite.sprite_frames = load(frames_path)
	unit.unit_sprite.play()

func parse_passives_string(s: String) -> Dictionary:
	if s == "" or s == null:
		return {}
	var result = JSON.parse_string(s)
	if typeof(result) != TYPE_DICTIONARY:
		return {}
	return result


var enemy_sets : Dictionary = {
	
	"set_1" : ["Ratron","Ratron","Skeltron","Skeltron"],
	"set_2" : ["Ratron","Ratron","Batron","Batron"],
	"set_3" : ["Ratron","Ratron","Spectroid","Spectroid"],
	"set_4" : ["Skeltron","Slitherbyte","Batron","Spectroid","Spectroid"],
	"set_5" : ["Skeltron","Slitherbyte","Slitherbyte","Spectroid","Armadroid"],
	"set_6" : ["Batron","Batron", "Batron", "Spidroid", "Spidroid","Armadroid"],
	"set_7" : ["Necrotron", "Demodroid", "Roblob", "Cacklebot","Batron","Batron"],
	"set_8" : ["Armadroid", "Armadroid", "Spidroid", "Slitherbyte","Slitherbyte"],
	"set_9" : ["Demodroid","Demodroid", "Armadroid", "Necrotron","Batron","Batron"]
}

var enemy_sets_easy := ["set_1","set_2","set_3"]
var enemy_sets_medium := ["set_4","set_5","set_6"]
var enemy_sets_difficult := ["set_7","set_8","set_9"]
