extends Action

var action_name := "heal_self"

func execute(context: Dictionary, action_source: Node = null,action_target: Node = null):
	
	var user = action_source
	
	if user.hp < user.max_hp:
		user.hp = min(user.max_hp, user.hp + context["amount"])
		Global.animate(user,Enums.Anim.FLASH,Color.GREEN)
		Global.float_text(str("+",context["amount"]),user.global_position,Color.GREEN)
		user.update()
