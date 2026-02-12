extends Action

var action_name := "attack"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	print ("executing acttack action")

	
	var sound_path : String
	
	if context.keys().has("sound_path"):
		sound_path = context["sound_path"]
	else:
		sound_path = "res://Audio/Sound_Effects/FGHTImpt_HIT-Strong Smack_HY_PC-003.wav"
	
	Global.audio_node.play_sfx(sound_path)
	await Global.animate(action_source_cell.occupant,Enums.Anim.LUNGE,Color.WHITE,action_target_cell)
	await action_target_cell.occupant.take_attack(context["amount"])
	await Global.timer(.1)
	await Global.timer(.2)
