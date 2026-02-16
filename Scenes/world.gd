extends Node2D

@onready var unit_layer : Node2D = $Unit_Layer
@onready var hero_layer: Node2D = $Hero_Layer

@onready var spell_ui: Node2D = $Spell_UI
@onready var player_ui: Control = $Player_UI
@onready var sum_label: Label = $DiceLayer/Sum_label
@onready var shop: Node2D = $Shop_Screen
@onready var effects_layer: Node2D = $Effects_Layer

@onready var overlay_layer: Node = $Overlay_Layer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Global.world = self
	Global.player_ui = $Player_UI
	Global.player_ui.update()
	call_deferred("game_start")

func game_start():
	
	await SkillManager.setup_dice()
	await UnitManager.spawn_torches()
	await UnitManager.spawn_starting_chests()
	await UnitManager.spawn_hero()
	await new_round()
	#await Global.audio_node.play_music("res://Audio/First Fruits3.ogg")
	
func new_round():
	
	InputManager.input_paused = true
	print ("new round started, round number is ", Global.round_number)
	await make_new_grid()
	await UnitManager.spawn_round_enemies()
	start_player_turn()

func make_new_grid():
	for x in Global.grid.all_cells:
		x.cell_effect = Enums.CellEffect.NONE
		x.update()
	var dupe_cells = Global.grid.all_cells.duplicate()
	for x in 5:
		var y = dupe_cells.pick_random()
		y.cell_effect = Enums.CellEffect.GRASS
		y.update()
		dupe_cells.erase(y)

func spawn_spells():
	for x in spell_ui.spell_slots:
		var spell_choice = SpellManager.spell_names.pick_random()
		SpellManager.insert_spell(spell_choice,x)
		
func roll_dice():
	if PlayerStats.rolls == 0:
		print ("no rolls left")
		return

	print ("rerolling")
	for x in Global.player_dice:
		if not x.used_this_turn: x.roll()
	
	PlayerStats.rolls -= 1
	Global.player_ui.update()

func start_player_turn():
	
	Global.game_state = Enums.GameState.PLAYER_TURN

	for x in Global.player_dice:
		x.used_this_turn = false
		x.grey_out = false
		
	PlayerStats.rolls = PlayerStats.max_rolls
	PlayerStats.spaces_moved_this_turn = 0
	
	await roll_dice()
	InputManager.input_paused = false
	
func end_player_turn():

	Global.game_state = Enums.GameState.ENEMY_TURN
	print ("TURN ENDED")
	
	enemy_turn()

func enemy_turn():
	
	print ("enemy turn started")
	
	var enemies = Global.grid.get_all_enemies().duplicate()
	print ("enemies to act are", enemies)
	
	for x in enemies:
		print ("checking enemy ", x, " for taking turn...")
		if not is_instance_valid(x):
			print ("enemy instance invalid, continuing")
			continue
		if x == null:
			print ("enemy instance null, continuing")
			continue
		await x.plan_action()
		
	end_enemy_turn()

func end_enemy_turn():
	for x in Global.grid.get_all_enemies().duplicate():
		
		if not is_instance_valid(x):
			continue
		
		await x.end_turn_effects()
		
	await Global.hero_unit.end_turn_effects()
	start_player_turn()

func victory_check():
	print ("running victory check...")
	var enemy_present := false
	for x in Global.grid.all_cells:
		if x.occupant != null:
			if x.occupant is Enemy:
				enemy_present = true
	
	print ("enemy present is ", enemy_present)
	if not enemy_present:
		print ("no enemy present, victory")
		victory()

func defeat():
	Global.game_state = Enums.GameState.ROUND_END
	print ("GAME OVER, DEFEAT!!!")

func victory():
	InputManager.input_paused = true
	Global.game_state = Enums.GameState.ROUND_END
	print ("ROUND OVER, VICTORY!!!")
	Global.round_number += 1
	
	enter_shop()

func reward():
	Global.game_state = Enums.GameState.REWARD
	var reward_inst : PackedScene = preload("res://Systems/Item System/Reward_Screen.tscn")
	var inst = reward_inst.instantiate()
	overlay_layer.add_child(inst)
	inst.get_new_rewards()
	
func enter_shop():
	
	Global.game_state = Enums.GameState.SHOP
	shop.visible = true
	await shop.get_new_level_ups()
	InputManager.input_paused = false

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

func kill_all_enemies():
	for x in Global.grid.all_cells:
		if x.occupant != null:
			if x.occupant is Enemy:
				ActionManager.create_action("enemy_death",{},x,x)
