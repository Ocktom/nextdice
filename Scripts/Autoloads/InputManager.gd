extends Node

var hovered_dice: Dice = null
var hovered_cell : Cell = null
var hovered_spell_slot : Spell_Slot = null
var hovered_item_slot : Item_Slot = null

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
		
		reset_all_hovered_variables()

signal unit_selected
signal cell_selected

func _input(event):
	
	if input_paused:
		return
	
	if Global.game_state == Enums.GameState.PLAYER_TURN:

#region standard turn controls

		# ---------- DRAGGING MOVEMENT ----------
		if event is InputEventMouseMotion:
			if dragging_dice != null:
				dragging_dice.face_node.global_position = event.position + drag_offset
			
			if dragging_unit != null:
				dragging_unit.global_position = event.position + unit_drag_offset

		if event.is_action_released("enter"):
			await reset_all_hovered_variables()
			await Global.world.end_turn()
		
		if event.is_action_released("f"):
			Global.world.kill_all_enemies()

		if event.is_action_released("space"):
			
			print ("space pressed")
			
			var used_count := 0
			for x in Global.player_dice:
				if x.used_this_turn: used_count += 1
			
			if Global.player_dice.size() == used_count:
				await Global.world.end_turn()
				return
			
			await Global.world.roll_dice()

		if event.is_action_released("right_mouse"):
			if hovered_dice is Dice:
				
				if hovered_dice.used_this_turn:
					Global.float_text("already used this turn",hovered_dice.global_position,Color.WHITE)
					return
				
				hovered_dice.use()

		elif event.is_action_released("left_mouse"):

			# Dice drop
			if dragging_dice is Dice:
				print ("dragging dice was dropped")
				
				if mana_area_hovered:
					Global.world.spell_ui.add_mana(dragging_dice.current_face.pips)
					dragging_dice.use()
				
				elif hovered_spell_slot != null:
					if hovered_spell_slot.occupant != null:
						if dragging_dice.current_face.pips >= hovered_spell_slot.occupant.mana_cost:
							hovered_spell_slot.occupant.use_spell()
							dragging_dice.use()
				
				elif not hovered_cell == null:
					if not hovered_cell.occupant == null:
						if hovered_cell.occupant is Enemy:
							if hovered_cell.is_adjacent(Global.hero_unit.current_cell, true):
								print ("dice dropped on enemy")
								dragging_dice.use()
								hovered_cell.occupant.take_attack(dragging_dice.current_face.pips)
								Global.world.call_deferred("victory_check")
							else:
								Global.float_text("Out of Range", Global.hero_unit.global_position)
								
							
						else:
							print ("dice dropped on non enemy unit")

					elif hovered_cell.is_empty():
						var hero_cell = Global.hero_unit.current_cell
						var max_move = dragging_dice.current_face.pips

						var dx = abs(hovered_cell.cell_vector.x - hero_cell.cell_vector.x)
						var dy = abs(hovered_cell.cell_vector.y - hero_cell.cell_vector.y)
						var dist = dx + dy

						if dist > max_move:
							print ("can't move, out of range")
							Global.float_text("Out of Range", Global.hero_unit.global_position)
							
						else:
							print("dragging dice is dropped on empty cell")
							hovered_cell.move_hero(dragging_dice)
							dragging_dice.use()

			
			# Reset dice drag
			if dragging_dice != null:
				dragging_dice.face_node.global_position = dragging_dice.global_position
				dragging_dice = null
		
		elif event.is_action_pressed("left_mouse"):

			# Dice drag start
			if hovered_dice is Dice:
				if hovered_dice.used_this_turn:
					Global.float_text("cooldown!",hovered_dice.global_position,Color.WHITE)
					return
				dragging_dice = hovered_dice
				drag_offset = dragging_dice.global_position - event.position
				return
		
			if hovered_spell_slot != null:
				if hovered_spell_slot.occupant != null:
					if Global.mana >= hovered_spell_slot.occupant.mana_cost:
						hovered_spell_slot.occupant.use_spell()
		
		#RIGHT MOUSE
		
		elif event.is_action_released("right_mouse"):
			print ("right mosue")
#endregion
	
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
		if event.is_action_pressed("left_mouse"):
			if hovered_item_slot != null:
				if hovered_item_slot.occupant != null:
					print ("PURCHASED ITEM IS ", hovered_item_slot.occupant)
					hovered_item_slot.clear_slot()
	
#region spell selection controls


#endregion

func reset_drag():
	if dragging_dice:
		dragging_dice.face_node.global_position = dragging_dice.global_position

	if dragging_unit:
		dragging_unit.global_position = unit_original_position

	dragging_dice = null
	dragging_unit = null
	drag_offset = Vector2.ZERO
	unit_drag_offset = Vector2.ZERO
		
#region debug controls

func reset_all_hovered_variables():
	hovered_cell = null
	hovered_dice = null
	hovered_spell_slot = null
	reset_drag()
