extends Action

var action_name := "heal_unit"

func execute(context: Dictionary, action_source: Node = null,action_target: Node = null):
	
	print ("heal action used")
	
	var user = action_source
	
	if user == Global.hero_unit:
		
		print ("heal target is player")
		
		if PlayerStats.player_hp < PlayerStats.max_hp:
			PlayerStats.player_hp = min(PlayerStats.max_hp, PlayerStats.player_hp + context["amount"])
			Global.animate(user,Enums.Anim.FLASH,Color.GREEN)
			Global.float_text(str("+",context["amount"]),user.global_position,Color.GREEN)
			user.update()
	
	if user is Enemy:
		print ("heal target is enemy")
		if user.hp < user.max_hp:
			user.hp = min(user.max_hp, user.hp + context["amount"])
			Global.animate(user,Enums.Anim.FLASH,Color.GREEN)
			Global.float_text(str("+",context["amount"]),user.global_position,Color.GREEN)
			user.update()
	
