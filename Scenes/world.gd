extends Node2D

@onready var unit_layer : Node2D = $Unit_Layer
@onready var spell_slots: Node2D = $Spell_Slots
@onready var player_ui: Control = $Player_UI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Global.world = self
	Global.player_ui = $Player_UI
	Global.player_ui.update()
	call_deferred("new_round")

func new_round():
	
	var starting_cell = Global.grid.all_cells.pick_random()
	var hero_scene : PackedScene = preload("res://Systems/Unit_System/Unit_Hero.tscn")
	var hero_inst = hero_scene.instantiate()
	hero_inst.unit_name = "HERO"
	Global.hero_unit = hero_inst
	starting_cell.spawn_unit(hero_inst)
	spell_slots.create_new_spells()
	
	for x in Global.starting_enemy_count:
		var unit_path : PackedScene = preload("res://Systems/Unit_System/Unit_Enemy.tscn")
		var cell_pick = Global.grid.get_empty_cells().pick_random()
		var unit_inst = unit_path.instantiate()
		cell_pick.spawn_unit(unit_inst)

func reroll():
	if Global.rolls == 0:
		print ("no rolls left")
		return

	print ("rerolling")
	for x in Global.player_dice:
		if not x.used_this_turn: x.roll()
	
	Global.rolls -= 1
	Global.player_ui.update()

func start_turn():
	for x in Global.player_dice:
		x.used_this_turn = false
		x.greyed_out = false
		
	Global.rolls = Global.max_rolls
	
func end_turn():
	print ("TURN ENDED")

func hover_dice(dice : Dice):
	
	if dice.used_this_turn: return
	
	for x in Global.grid.all_cells:
		
		if x.occupant == null:
			continue

func unhover_dice():
	
	for x in Global.grid.all_cells:
		if x.occupant == null: 
			continue
		if x.occupant.highlight: x.occupant.toggle_highlight()
