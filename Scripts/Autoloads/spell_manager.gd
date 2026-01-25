extends Node

var spell_data_dictionary : Dictionary
var enemy_data
var spell_names : Array
var spell_awaiting_selection : Spell = null
var selected_target : Node2D

signal selection_complete

func _ready() -> void:
	
	var spell_data_script = load("res://Systems/Spell System/spell_data_dictionary.gd").new()
	spell_data_dictionary = spell_data_script.data
	spell_names = spell_data_dictionary.keys()

func insert_spell(spell_name : String, spell_slot: Spell_Slot):
	print("inserting spell")

	var spell_data = spell_data_dictionary[spell_name]
	var spell_path : PackedScene = preload("res://Systems/Spell System/Spell.tscn")
	var spell_inst = spell_path.instantiate()

	print("spell data being inserted is ", spell_data)

	spell_inst.spell_name = spell_name
	spell_inst.mana_cost = spell_data["mana_cost"]
	spell_inst.target_type = Enums.TargetType[spell_data["target_type"]]
	spell_inst.value_1 = spell_data["value_1"]
	
	spell_slot.fill_with_spell(spell_inst)
	
func select_unit(spell : Spell):
	print ("select_unit running in SpellManager")
	spell_awaiting_selection = spell
	InputManager.unit_selected.connect(_on_unit_selected)
	Global.game_state = Enums.GameState.SELECT_TARGET_UNIT
	
func select_cell(spell: Spell):
	spell_awaiting_selection = spell
	InputManager.cell_selected.connect(_on_cell_selected)
	Global.game_state = Enums.GameState.SELECT_TARGET_CELL
	
func _on_unit_selected(selected_target : Unit):
	print ("target selected is", selected_target)
	selection_complete.emit(selected_target)
	Global.game_state = Enums.GameState.PLAYER_TURN
	
func _on_cell_selected(selected_target: Cell):
	print ("cell selected is", selected_target)
	selection_complete.emit(selected_target)
	Global.game_state = Enums.GameState.PLAYER_TURN
