extends Action

var action_name := "move_unit"

func execute(context: Dictionary, unit_current_cell: Cell = null, target_cell: Cell = null):
	
	var color : Color
	var unit_to_move = unit_current_cell.occupant
	
	var spaces_moved = Global.grid.get_distance(unit_current_cell,target_cell)
	PlayerStats.spaces_moved_this_turn += spaces_moved
	
	Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNMisc_MOVEMENT-Retro Jump_HY_PC-001.wav")
	target_cell.fill_with_unit(unit_to_move)
	
	unit_current_cell.clear_cell()
	
