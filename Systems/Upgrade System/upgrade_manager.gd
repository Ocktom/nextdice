extends Node

var upgrade_data_dictionary : Dictionary
var upgrade_names = upgrade_data_dictionary.keys()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var upgrade_data_script = load("res://Systems/Upgrade System/upgrade_data_dictionary.gd").new()
	upgrade_data_dictionary = upgrade_data_script.data
	upgrade_names = upgrade_data_dictionary.keys()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func insert_upgrade(upgrade_name : String, dice_face: Face):
	print("inserting upgrade")
	var upgrade_data = upgrade_data_dictionary[upgrade_name]
	dice_face.upgrade[upgrade_name] = upgrade_data
	
func attack_effects(unit: Unit, amount : int, dice: Dice):
	
	var face = dice.current_face
	
	if face.upgrade.keys().has("cleave"):
		
		var cleave_cells = Global.grid.get_cleave_targets(Global.hero_unit.current_cell,unit.current_cell)
		var cleave_units : Array[Unit] = []
		var cleave_amount = amount/2
		
		for x in cleave_cells:
			if x.occupant != null:
				cleave_units.append(x.occupant)
		
		for x in cleave_units:
			await ActionManager.request_action("damage_unit",{"target" : x, "amount" : amount/2, "damage_name" : "physical"},Global.hero_unit,x)

	if face.upgrade.keys().has("impale"):
		
		print ("matching SPEAR effect")
		
		var impale_cell = Global.grid.get_impale_target(Global.hero_unit.current_cell,unit.current_cell)
		if impale_cell != null:
			if impale_cell.occupant != null:
				var impale_unit = impale_cell.occupant
				await ActionManager.request_action("damage_unit",{"target" : impale_unit, "amount" : amount, "damage_name" : "physical"},Global.hero_unit,impale_unit)
