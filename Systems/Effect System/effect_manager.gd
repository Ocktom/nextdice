extends Node

var effect_data_dictionary : Dictionary
var effect_names = effect_data_dictionary.keys()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var effect_data_script = load("res://Systems/Effect System/effect_data_dictionary.gd").new()
	effect_data_dictionary = effect_data_script.data
	effect_names = effect_data_dictionary.keys()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func insert_effect(effect_name : String, dice_face: Face):
	print("inserting effect of ", effect_name, " into dice face of ", dice_face)

	var effect_data = effect_data_dictionary[effect_name]
	dice_face.effect[effect_name] = effect_data
	
func attack_effects(unit: Unit, amount : int, dice: Dice):
	
	var face = dice.current_face
	
	if face.effect.keys().has("cleave"):
		
		var cleave_cells = Global.grid.get_cleave_targets(Global.hero_unit.current_cell,unit.current_cell)
		var cleave_units : Array[Unit] = []
		var cleave_amount = amount/2
		
		for x in cleave_cells:
			if x.occupant != null:
				cleave_units.append(x.occupant)
		
		for x in cleave_units:
			await ActionManager.request_action("damage_unit",{"target" : x, "amount" : amount/2, "damage_name" : "physical"},unit.current_cell,x.current_cell)

	if face.effect.keys().has("impale"):
		
		print ("matching SPEAR effect")
		
		var impale_cell = Global.grid.get_impale_target(Global.hero_unit.current_cell,unit.current_cell)
		if impale_cell != null:
			if impale_cell.occupant != null:
				var impale_unit = impale_cell.occupant
				await ActionManager.request_action("damage_unit",{"target" : impale_cell, "amount" : amount, "damage_name" : "physical"},unit.current_cell,impale_cell)
