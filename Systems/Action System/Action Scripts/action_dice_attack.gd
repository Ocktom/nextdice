extends Action

var action_name := "dice_attack"

func execute(context: Dictionary, action_source: Node = null, action_target: Node = null):
	
	var user = action_source
	var target = context["target"]
	var dice = context["dice"]

	await Global.animate(action_source,Enums.Anim.LUNGE,Color.WHITE,target)
	await target.take_attack(context["amount"])
	await GearManager.attack_effects(target,context["amount"],context["dice"])
	await Global.timer(.1)
	SignalBus.unit_attacked.emit(target,self)
	SignalBus.enemy_attacked.emit(target)
	Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNMisc_HIT-Bit Kick_HY_PC-002.wav")
	await Global.timer(.2)
