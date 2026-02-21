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
	
	var starting_status_effects = parse_status_effects_string(data["status_effects"])
	for x in starting_status_effects.keys():
		unit.status_effects[x] = int(starting_status_effects[x]["amount"])
	
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

func parse_status_effects_string(s: String) -> Dictionary:
	if s == "" or s == null:
		return {}
	var result = JSON.parse_string(s)
	if typeof(result) != TYPE_DICTIONARY:
		return {}
	return result

var enemy_sets : Dictionary = {
	
	"set_1" : ["Armadroid","Roblob","Bomberbot","Skeltron","Demodroid"],
	"set_2" : ["Armadroid","Roblob","Armadroid","Skeltron"],
	"set_3" : ["Bomberbot","Roblob","Roblob","Bomberbot"],
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

func spawn_torches():
	var unit_scene : PackedScene = preload("res://Systems/Unit_System/Unit_Torch.tscn")
	for x in Global.torch_unit_count:
		var inst = unit_scene.instantiate()
		inst.unit_name = "Torch"
		var cell = Global.grid.get_empty_cells().pick_random()
		await cell.spawn_unit(inst)

func spawn_starting_chests():
	for x in PlayerStats.starting_chests:
		var chest_path : PackedScene = preload("res://Systems/Unit_System/Unit_Chest.tscn")
		var inst = chest_path.instantiate()
		var cell_pick = Global.grid.get_empty_cells().pick_random()
		await cell_pick.spawn_unit(inst)
		
func spawn_hero():
	
	var cell_pick = Global.grid.get_empty_cells().pick_random()
	var hero_scene : PackedScene = preload("res://Systems/Unit_System/Unit_Hero.tscn")
	var hero_inst = hero_scene.instantiate()
	hero_inst.unit_name = "HERO"
	Global.hero_unit = hero_inst
	cell_pick.spawn_unit(hero_inst)

func spawn_round_enemies():
	
	var enemy_set : String
	var enemy_names : Array
	
	if Global.round_number <= 3:
		enemy_set = UnitManager.enemy_sets_easy.pick_random()
	if (Global.round_number > 3 && Global.round_number <= 6):
		print ("picking enemy set from ", UnitManager.enemy_sets_medium)
		enemy_set = UnitManager.enemy_sets_medium.pick_random()
	if (Global.round_number > 6):
		enemy_set = UnitManager.enemy_sets_difficult.pick_random()
	
	print ("enemy_set is ", enemy_set)
	enemy_names = UnitManager.enemy_sets[enemy_set]
	
	var hero_cell = Global.hero_unit.current_cell
	var forbidden_cells = Global.grid.get_adjacent_cells(hero_cell)
	forbidden_cells.append(hero_cell)
	
	print ("enemy names is ", enemy_names)
	for x in enemy_names:
		
		var valid_cells = []

		for cell in Global.grid.get_empty_cells():
			if not forbidden_cells.has(cell):
				valid_cells.append(cell)

		if valid_cells.is_empty():
			print ("no valid cells to spawn enemy to")
			return

		var cell_pick = valid_cells.pick_random()
		
		UnitManager.spawn_new_enemy(x,cell_pick)
