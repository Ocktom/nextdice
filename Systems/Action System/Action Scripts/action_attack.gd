extends Action

var action_name := "attack"

func execute(context: Dictionary, action_source: Node = null,action_target: Node = null):
	
	print ("executing acttack action")
	var user = action_source
	var target = context["target"]
	
	await Global.animate(action_source,Enums.Anim.LUNGE,Color.WHITE,target)
	await target.take_attack(context["amount"])
	await Global.timer(.1)
	SignalBus.unit_attacked.emit()
	Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNMisc_HIT-Bit Kick_HY_PC-002.wav")
	await Global.timer(.2)
