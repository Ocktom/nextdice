extends Action

var action_name := "attack"

func execute(context: Dictionary, action_source: Node = null, action_target: Node = null):
	
	print ("executing acttack action")
	var user = action_source
	var target = context["target"]
	var sound_path : String
	
	if context.keys().has("sound_path"):
		sound_path = context["sound_path"]
	else:
		sound_path = "res://Audio/Sound_Effects/FGHTImpt_HIT-Strong Smack_HY_PC-003.wav"
	
	Global.audio_node.play_sfx(sound_path)
	await Global.animate(action_source,Enums.Anim.LUNGE,Color.WHITE,target)
	await target.take_attack(context["amount"])
	await Global.timer(.1)
	SignalBus.unit_attacked.emit()
	await Global.timer(.2)
