extends Action

var action_name := "increase_attack_self"

func execute(context: Dictionary, action_source: Node = null,action_target: Node = null):
	
	print ("executing action script of ", action_name, " with context ", context)
	
	var user = action_source
	
	if user.atk > 1: 
		user.atk += context["amount"]
		Global.animate(user,Enums.Anim.FLASH,Color.ORANGE_RED)
		Global.float_text(str("+",context["amount"], " ATK"),user.global_position,Color.ORANGE_RED)
		user.update()
		await Global.timer(.5)
