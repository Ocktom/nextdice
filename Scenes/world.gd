extends Node2D

@onready var unit_layer : Node2D = $Unit_Layer
@onready var hero_layer: Node2D = $Hero_Layer

@onready var spell_ui: Node2D = $Spell_UI
@onready var player_ui: Control = $Player_UI
@onready var sum_label: Label = $DiceLayer/Sum_label
@onready var shop: Node2D = $Shop_Screen
@onready var effects_layer: Node2D = $Effects_Layer

@onready var dice_container: HBoxContainer = $DiceLayer/Dice_Container

@onready var overlay_layer: Node = $Overlay_Layer
@onready var float_layer: Node = $Float_Layer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Global.world = self
	Global.player_stats = $Services/Player_Stats
	Global.player_ui = $Player_UI
	Global.player_ui.update()
	await call_deferred("game_start")
	
func game_start():
	
	await DiceManager.create_dice()
	await DiceManager.setup_dice()
	await UnitManager.spawn_torches()
	await UnitManager.spawn_starting_chests()
	await UnitManager.spawn_hero()
	await new_round()
	await Global.audio_node.play_music("res://Audio/First Fruits3.ogg")
	
func new_round():
	
	InputManager.input_paused = true
	print ("new round started, round number is ", Global.round_number)
	await make_new_grid()
	await clear_all_units()
	await UnitManager.spawn_round_enemies()
	await UnitManager.spawn_starting_chests()
	await UnitManager.spawn_hero()
	
	start_player_turn()

func clear_all_units():
	for x in Global.grid.all_cells:
		if x.occupant != null:
			x.occupant.queue_free()
			x.clear_cell()

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

func roll_dice():
	if Global.player_stats.rolls == 0:
		print ("no rolls left")
		return

	print ("rerolling")
	for x in Global.player_dice:
		if not x.used_this_turn: x.roll()
	
	Global.player_stats.rolls -= 1
	Global.player_ui.update()

func start_player_turn():
	
	print ("player_turn started in world node")
	
	Global.game_state = Enums.GameState.PLAYER_TURN

	for x in Global.player_dice:
		x.used_this_turn = false
		x.grey_out = false
		
	Global.player_stats.rolls = Global.player_stats.max_rolls
	Global.player_stats.spaces_moved_this_turn = 0
	Global.player_stats.move_points = Global.player_stats.max_move_points
	
	await roll_dice()
	InputManager.input_paused = false
	
func end_player_turn():

	Global.game_state = Enums.GameState.ENEMY_TURN
	
	await EventManager.explode_bombs()
	
	if Global.game_state == Enums.GameState.ENEMY_TURN:
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
		await StatusManager.start_turn_effects(x)
	
	for x in enemies:
		print ("checking enemy ", x, " for taking turn...")
		if not is_instance_valid(x):
			print ("enemy instance invalid, continuing")
			continue
		if x == null:
			print ("enemy instance null, continuing")
			continue
		
		await x.plan_action()
		
	await end_enemy_turn()

func end_enemy_turn():
	
	print ("end_enemy_turn run in world node")
	
	for x in Global.grid.get_all_enemies():
		
		print ("world node checking end_turn effects for unit ", x.unit_name)
		
		if not is_instance_valid(x):
			continue
		
		await StatusManager.end_turn_effects(x)
	
	print ("end_turn_effects complete in world node for enemies")
	
	if Global.game_state == Enums.GameState.ENEMY_TURN:
	
		await Global.hero_unit.end_turn_effects()
		start_player_turn()

func victory_check():
	
	print ("running victory check in world node...")
	var enemy_present := false
	for x in Global.grid.all_cells:
		if x.occupant != null:
			if x.occupant is Enemy:
				enemy_present = true
	
	print ("enemy present is ", enemy_present)
	
	if not enemy_present:
		print ("no enemy present, victory")
		await victory()

func defeat():
	
	Global.game_state = Enums.GameState.ROUND_END
	InputManager.input_paused = true
	await Global.main.load_scene(Global.main.defeat_path,true)
	print ("GAME OVER, DEFEAT!!!")

func victory():
	InputManager.input_paused = true
	Global.game_state = Enums.GameState.ROUND_END
	print ("ROUND OVER, VICTORY!!!")
	Global.round_number += 1
	new_round()

func reward():
	Global.game_state = Enums.GameState.REWARD
	var reward_inst : PackedScene = preload("res://Systems/Item System/Reward_Screen.tscn")
	var inst = reward_inst.instantiate()
	overlay_layer.add_child(inst)
	inst.get_new_rewards(Enums.ItemType.GEAR)

func find_gear():
	Global.game_state = Enums.GameState.FIND_GEAR
	var reward_inst : PackedScene = preload("res://Systems/Item System/find_gear.tscn")
	var inst = reward_inst.instantiate()
	overlay_layer.add_child(inst)

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
				ActionManager.request_action("enemy_death",{},x,x)
