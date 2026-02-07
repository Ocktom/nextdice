extends Action

var action_name := "shield_self"

func execute(context: Dictionary, action_source: Node = null, action_target: Node = null):
	
	var amount = max(1,context["amount"])
	var status_name = "shield"
	
	if action_target.status_effects.keys().has(status_name):
		action_target.status_effects[status_name] = max(amount, action_target.status_effects[status_name]+amount)
	else:
		action_target.status_effects[status_name] = amount
	
	print ("the amount of ", status_name, " in ", action_target.unit_name, "'s status dictionary is ", action_target.status_effects[status_name])
	
	Global.float_text(str(status_name, " +",amount),action_target.global_position,Color.WHITE)
	
	action_target.update()
	Global.animate(action_target,Enums.Anim.FLASH,Color.GREEN)
	Global.float_text("SHIELD",action_target.global_position,Color.GREEN)
	action_target.update()
