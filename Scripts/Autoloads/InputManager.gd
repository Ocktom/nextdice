extends Node

var hovered_dice: Dice = null
var hovered_cell : Cell = null
var hovered_item_slot : Item_Slot = null

var hovered_gear : GearSlot = null
var dragging_gear : GearSlot = null
var gear_original_position : Vector2

var mana_area_hovered := false

# Drag state
var dragging_dice: Dice = null
var drag_offset: Vector2

# Unit drag
var dragging_unit: Unit = null
var unit_drag_offset: Vector2
var unit_original_position: Vector2

var input_paused : 
	set(new_value):
		if input_paused != new_value:
			input_paused = new_value

		for x in Global.player_dice:
			if not x.used_this_turn:
				x.grey_out = input_paused
		
		#Global.unhighlight_cells()
		#reset_all_hovered_variables()

signal unit_selected
signal cell_selected

func _input(event):
	
	if input_paused:
		print ("input paused, returning out of input")
		return
	
	if Global.game_state == Enums.GameState.PLAYER_TURN:

#region PLAYERTURN input starts here

		# ---------- DRAGGING MOVEMENT ----------
		if event is InputEventMouseMotion:
			
			if dragging_dice != null:
				dragging_dice.face_node.global_position = event.position + drag_offset
			
			if dragging_unit != null:
				dragging_unit.global_position = event.position + unit_drag_offset

		if event.is_action_released("enter"):
			
			call_deferred("reset_all_hovered_variables")
			Global.world.call_deferred("end_player_turn")
		
		if event.is_action_released("f"):
			Global.world.kill_all_enemies()

		if event.is_action_released("space"):
			
			print ("space pressed")
			
			var used_count := 0
			for x in Global.player_dice:
				if x.used_this_turn: used_count += 1
			
			if Global.player_dice.size() == used_count:
				await Global.world.end_player_turn()
				return
			
			await Global.world.roll_dice()

		if event.is_action_released("right_mouse"):
			
			if hovered_dice is Dice:
				
				if hovered_dice.used_this_turn:
					Global.float_text("already used this turn",hovered_dice.global_position,Color.WHITE)
					return
				
				#hovered_dice.use()
			
			elif hovered_cell != null:
					if hovered_cell.occupant != null:
						if hovered_cell.occupant is Chest:
							await hovered_cell.occupant.open_chest()
							return
			
		elif event.is_action_released("left_mouse"):

			# Dice drop
			if dragging_dice is Dice:
				print ("dragging dice was dropped, hovered cell is ", hovered_cell)
				
				
				if mana_area_hovered:
					print ("using dice for mana")
					Global.world.spell_ui.add_mana(dragging_dice.current_face.pips)
					
				elif not hovered_cell == null:
					print ("hovered cell not null")
					
					if DiceManager.is_useable(dragging_dice,hovered_cell):
						print ("dice is useable, using...")
						dragging_dice.use(Global.hero_unit.current_cell,hovered_cell)
					else:
						print ("dice is NOT useable, resetting")
						reset_drag()
						return
				
				#Unit Drop
			if dragging_unit is Hero:
				print ("dropped hero")
				if hovered_cell != null:
					if hovered_cell.is_empty():
						var distance = Global.grid.get_distance(Global.hero_unit.current_cell,hovered_cell)
						if Global.player_stats.move_points >= distance:
							print ("moving hero")
							Global.action_manager.request_action("hero_movement",{},Global.hero_unit.current_cell,hovered_cell)
						else:
							Global.float_text("NOT ENOUGH MOVE POINTS",hovered_cell.global_position)
					
			# Reset dice drag
			reset_drag()
		
		elif event.is_action_pressed("left_mouse"):

			# Dice drag start
			
			if hovered_dice is Dice:
				if hovered_dice.used_this_turn:
					
					Global.float_text("cooldown!",hovered_dice.global_position,Color.WHITE)
					return
				
				if hovered_dice.current_face.skill.skill_target == Enums.SkillTarget.SELF:
					print ("using skill on self")
					await hovered_dice.use(Global.hero_unit.current_cell,Global.hero_unit.current_cell)
					return
				
				dragging_dice = hovered_dice
				drag_offset = dragging_dice.global_position - event.position
				
				DiceManager.highlight_useable_cells(hovered_dice)
				
				return
			
			if hovered_cell != null:
				if hovered_cell.occupant != null:
					if hovered_cell.occupant is Hero:
						dragging_unit = Global.hero_unit
						drag_offset = dragging_unit.global_position - event.position
				
		#RIGHT MOUSE
		
		elif event.is_action_released("esc"):
			await Global.main.enter_inventory_screen()
			return
			
#endregion PLAYERTURN input ends here

#region INVENTORY input begins here

	if Global.game_state == Enums.GameState.INVENTORY:
		
		if event.is_action_released("esc"):
			await Global.main.resume_game()
			
		if event is InputEventMouseMotion:
			if dragging_gear != null:
				dragging_gear.gear_texture.global_position = event.position + drag_offset
		
		if event.is_action_released("left_mouse"):
			
			if dragging_gear is GearSlot:
				if hovered_gear is GearSlot:
					Global.inventory.insert_gear_from_slot(dragging_gear,hovered_gear)
				
				reset_drag()
				return
		
		if event.is_action_pressed("left_mouse"):
				if hovered_gear is GearSlot:
					gear_original_position = hovered_gear.gear_texture.global_position
					dragging_gear = hovered_gear
					drag_offset = dragging_gear.gear_texture.global_position - event.position
	
	if Global.game_state == Enums.GameState.FIND_GEAR:
		if event.is_action_pressed("right_mouse"):
			if hovered_gear is GearSlot:
				await GearManager.drop_gear(hovered_gear.gear_name)
				
	
	if Global.game_state == Enums.GameState.SELECT_TARGET_UNIT:
		if event.is_action_pressed("left_mouse"):
			if hovered_cell != null:
				if hovered_cell.occupant != null:
					unit_selected.emit(hovered_cell.occupant)
			
	if Global.game_state == Enums.GameState.SELECT_TARGET_CELL:
		if event.is_action_pressed("left_mouse"):
			if hovered_cell != null:
				cell_selected.emit(hovered_cell)
	
	if Global.game_state == Enums.GameState.SHOP:
		if event.is_action_released("left_mouse"):
			if hovered_item_slot != null:
				if hovered_item_slot.occupant != null:
					Global.world.shop.buy_item(hovered_item_slot)
					
		elif event.is_action_released("enter"):
			Global.world.shop.visible = false
			Global.world.new_round()
		
#region spell selection controls

#endregion

func reset_drag():
	
	if dragging_dice:
		dragging_dice.face_node.global_position = dragging_dice.global_position

	if dragging_unit:
		dragging_unit.global_position = dragging_unit.current_cell.global_position
	
	if dragging_gear:
		dragging_gear.gear_texture.global_position = gear_original_position
	
	dragging_dice = null
	dragging_unit = null
	dragging_gear = null
	drag_offset = Vector2.ZERO
	unit_drag_offset = Vector2.ZERO
	
	print ("reset drag function calling unhilight cells")
	Global.unhighlight_cells()
		
#region debug controls

func reset_all_hovered_variables():
	hovered_cell = null
	hovered_dice = null
	hovered_gear = null
	
	reset_drag()
