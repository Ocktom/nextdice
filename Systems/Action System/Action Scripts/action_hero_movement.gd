extends Action

var action_name := "move_unit"

func execute(context: Dictionary, unit_current_cell: Cell = null, target_cell: Cell = null):
	
	var color : Color
	var unit_to_move = unit_current_cell.occupant
	
	print ("move_unit script running, unit to move is, ", unit_to_move.unit_name, " former cell is ", unit_current_cell.cell_vector, " target_cell is ", target_cell.cell_vector)
	
	var spaces_moved = Global.grid.get_distance(unit_current_cell,target_cell)
	
	Global.player_stats.spaces_moved_this_turn += spaces_moved
	Global.player_stats.move_points -= spaces_moved
	
	Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNMisc_MOVEMENT-Retro Jump_HY_PC-001.wav")
	await target_cell.fill_with_unit(unit_to_move)
	
	print ("after fill with unit called, target_cell of, ", target_cell, " occupant is ", target_cell.occupant)
	
	await Global.event_manager.on_unit_moved(unit_to_move,unit_current_cell,target_cell)
	
	unit_current_cell.clear_cell()
	Global.world.player_ui.update()
