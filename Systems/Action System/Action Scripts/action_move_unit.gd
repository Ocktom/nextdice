extends Action

var action_name := "move_unit"

func execute(context: Dictionary, action_source: Node = null,action_target: Node = null):
	
	var user = action_source
	var color : Color
	
	Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNMisc_MOVEMENT-Retro Jump_HY_PC-001.wav")
	action_source.current_cell.clear_cell()
	action_target.fill_with_unit(action_source)
