extends Node2D

@onready var unit_layer : Node2D = $Unit_Layer
@onready var spell_ui: Node2D = $Spell_UI
@onready var player_ui: Control = $Player_UI
@onready var sum_label: Label = $DiceLayer/Sum_label
@onready var shop: Node2D = $Shop_Screen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Global.world = self
	Global.player_ui = $Player_UI
	Global.player_ui.update()
	call_deferred("game_start")

func game_start():
	await spawn_hero()
	await spawn_spells()
	await new_round()

func new_round():
	
	InputManager.input_paused = true
	print ("new round started, round number is ", Global.round_number)
	await spawn_round_enemies()
	start_player_turn()
	
	for x in Global.player_dice:
		for y in x.faces:
			GearManager.insert_gear("spear",y)

func spawn_hero():
	
	var starting_cell = Global.grid.all_cells.pick_random()
	var hero_scene : PackedScene = preload("res://Systems/Unit_System/Unit_Hero.tscn")
	var hero_inst = hero_scene.instantiate()
	hero_inst.unit_name = "HERO"
	Global.hero_unit = hero_inst
	starting_cell.spawn_unit(hero_inst)
	spell_ui.create_new_spells()

func spawn_spells():
	for x in spell_ui.spell_slots:
		var spell_choice = SpellManager.spell_names.pick_random()
		SpellManager.insert_spell(spell_choice,x)

func spawn_round_enemies():
	
	var enemy_count = Global.starting_enemy_count
	if Global.round_number > 1:
		enemy_count += Global.round_number
	
	var hero_cell = Global.hero_unit.current_cell
	var forbidden_cells = Global.grid.get_adjacent_cells(hero_cell)
	forbidden_cells.append(hero_cell)
	
	for x in enemy_count:
		
		var valid_cells = []

		for cell in Global.grid.get_empty_cells():
			if not forbidden_cells.has(cell):
				valid_cells.append(cell)

		if valid_cells.is_empty():
			print ("no valid cells to spawn enemy to")
			return

		var cell_pick = valid_cells.pick_random()
		
		var enemy_name = UnitManager.enemy_names.pick_random()
		UnitManager.spawn_new_enemy(enemy_name,cell_pick)
		
func roll_dice():
	if Global.rolls == 0:
		print ("no rolls left")
		return

	print ("rerolling")
	for x in Global.player_dice:
		if not x.used_this_turn: x.roll()
	
	Global.rolls -= 1
	Global.player_ui.update()
	update_sum()

func start_player_turn():
	
	Global.game_state = Enums.GameState.PLAYER_TURN

	SignalBus.turn_start.emit()

	for x in Global.player_dice:
		x.used_this_turn = false
		x.grey_out = false
		
	Global.rolls = Global.max_rolls
	await roll_dice()
	InputManager.input_paused = false
	
func end_player_turn():
	
	for x in Global.player_dice:
		if not x.used_this_turn:
			spell_ui.add_mana(x.current_face.pips)
	
	Global.game_state = Enums.GameState.ENEMY_TURN
	print ("TURN ENDED")
	await Global.hero_unit.end_turn_effects()
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
	for x in Global.grid.get_all_enemies():
		await x.end_turn_effects()
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
		
func enter_shop():
	
	Global.game_state = Enums.GameState.SHOP
	shop.visible = true
	await shop.get_new_items()
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
				ActionManager.create_action("enemy_death",{},x.occupant)

func update_sum():
	var new_sum = 0
	for x in Global.player_dice:
		if not x.used_this_turn:
			new_sum += x.current_face.pips
	Global.current_sum = new_sum
	sum_label.text = str(Global.current_sum)
	
