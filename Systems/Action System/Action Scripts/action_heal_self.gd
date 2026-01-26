extends Node

var action_name := "heal_self"

func execute(context: Dictionary):
	
	var user = context["source"]
	if user.hp < user.max_hp:
		user.hp = min(user.max_hp, user.hp + context["amount"])
