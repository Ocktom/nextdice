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
	
func attack_effects(unit: Unit, amount : int, dice: Dice):
	
	var face = dice.current_face
	
	if face.gear.keys().has("great_axe"):
		
		var cleave_cells = Global.grid.get_cleave_targets(Global.hero_unit.current_cell,unit.current_cell)
		var cleave_units : Array[Unit] = []
		var cleave_amount = amount/2
		
		
		for x in cleave_cells:
			if x.occupant != null:
				cleave_units.append(x.occupant)
		
		for x in cleave_units:
			await ActionManager.request_action("secondary_attack",{"target" : x, "amount" : cleave_amount},Global.hero_unit,x)
	
	if face.gear.keys().has("spear"):
		
		print ("matching SPEAR effect")
		
		var impale_cell = Global.grid.get_impale_target(Global.hero_unit.current_cell,unit.current_cell)
		if impale_cell != null:
			if impale_cell.occupant != null:
				var impale_unit = impale_cell.occupant
				await ActionManager.request_action("secondary_attack",{"target" : impale_unit, "amount" : amount},
													Global.hero_unit,impale_unit)
