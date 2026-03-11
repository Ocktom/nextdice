extends Action

var action_name := "move_unit"

func execute(context: Dictionary, unit_current_cell: Cell = null, target_cell: Cell = null):
	
		
	var unit_to_move = unit_current_cell.occupant

	if target_cell.occupant != null:
		Global.float_text("ERROR, space full",target_cell.global_position,Color.RED)
		return

	# --- Fix grid state first ---
	unit_current_cell.clear_cell()
	target_cell.occupant = unit_to_move
	unit_to_move.current_cell = target_cell

	# --- Then visuals ---
	Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNMisc_MOVEMENT-Retro Jump_HY_PC-001.wav")
	unit_to_move.global_position = target_cell.global_position

	# --- Then events ---
	print ("move_unit script calling event_manager.on_unit_moved, with unit of ", unit_to_move.unit_name)
	await Global.event_manager.on_unit_moved(unit_to_move,unit_current_cell,target_cell)
	
