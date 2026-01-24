extends Node

var hovered_dice: Dice = null
var hovered_cell : Cell = null
var hovered_card : Card = null

# Drag state
var dragging_dice: Dice = null
var drag_offset: Vector2

# Card drag
var dragging_card: Card = null
var card_drag_offset: Vector2
var card_original_position: Vector2

var input_paused : 
	set(new_value):
		if input_paused != new_value:
			input_paused = new_value

		for x in Global.player_dice:
			if not x.used_this_turn:
				x.grey_out = input_paused
		
		reset_all_hovered_variables()

func _input(event):
	
	if input_paused:
		return
	
	if Global.game_state == Enums.GameState.REWARD:
		
		if event.is_action_released("left_mouse"):
			print ("should have picked...")
			pass
	
	if Global.game_state == Enums.GameState.PLAYER_TURN:

#region standard turn controls

		# ---------- DRAGGING MOVEMENT ----------
		if event is InputEventMouseMotion:
			if dragging_dice != null:
				dragging_dice.face_node.global_position = event.position + drag_offset
			
			if dragging_card != null:
				dragging_card.global_position = event.position + card_drag_offset


		if event.is_action_released("enter"):
			await reset_all_hovered_variables()
			await Global.main_scene.end_turn()


		if event.is_action_released("space"):
			var dice_used := 0
			for x in Global.player_dice:
				if x.used_this_turn: dice_used += 1
			
			if Global.player_dice.size() == dice_used:
				Global.main_scene.end_turn()
				return
			
			await Global.main_scene.reroll()


		if event.is_action_released("right_mouse"):
			if hovered_dice is Dice:
				await hovered_dice.return_dice()


		elif event.is_action_released("left_mouse"):

			# Dice drop
			if dragging_dice is Dice:
				print ("dragging dice was dropped")
				if not hovered_cell == null:
					if hovered_cell.is_empty(): 
						print ("dragging dice is dropped on empty cell")
						hovered_cell.insert_dice(dragging_dice)

			# Reset dice drag
			if dragging_dice != null:
				dragging_dice.face_node.global_position = dragging_dice.global_position
				dragging_dice = null


		
		elif event.is_action_pressed("left_mouse"):

			# Dice drag start
			if hovered_dice is Dice:
				dragging_dice = hovered_dice
				drag_offset = dragging_dice.global_position - event.position
				return
		#RIGHT MOUSE
		elif event.is_action_released("right_mouse"):
			print ("right mosue")
		
#endregion

func reset_drag():
	if dragging_dice:
		dragging_dice.face_node.global_position = dragging_dice.global_position

	if dragging_card:
		dragging_card.global_position = card_original_position

	dragging_dice = null
	dragging_card = null
	drag_offset = Vector2.ZERO
	card_drag_offset = Vector2.ZERO
		
#region debug controls

func reset_all_hovered_variables():
	hovered_card = null
	hovered_cell = null
	hovered_dice = null
	reset_drag()
