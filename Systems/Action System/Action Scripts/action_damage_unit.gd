extends Action

var action_name := "damage"

func execute(context: Dictionary, action_source: Node = null,action_target: Node = null):
	
	var user = action_source
	var color : Color
	
	match context["damage_name"]:
		"poison" : color = Color.GREEN
	
	Global.float_text(context["damage_name"],action_target.global_position,color)
	Global.animate(action_target,Enums.Anim.SHAKE)
	Global.animate(action_target,Enums.Anim.FLASH,color)
	SignalBus.unit_damaged.emit(action_target,self)
	action_target.take_non_attack_damage(context["amount"])
	
	await Global.timer(.4)
