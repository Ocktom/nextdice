extends Action

var action_name := "heal_unit"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	print ("heal action used")
	
	var user = action_source_cell.occupant
	var target = action_target_cell.occupant
	
	if target == Global.hero_unit:
		
		print ("heal target is player")
		
		if PlayerStats.player_hp < PlayerStats.max_hp:
			PlayerStats.player_hp = min(PlayerStats.max_hp, PlayerStats.player_hp + context["amount"])
			Global.animate(target,Enums.Anim.FLASH,Color.GREEN)
			Global.float_text(str("+",context["amount"]),target.global_position,Color.GREEN)
			target.update()
	
	if target is Enemy:
		print ("heal target is enemy")
		if target.hp < target.max_hp:
			target.hp = min(user.max_hp, target.hp + context["amount"])
			Global.animate(target,Enums.Anim.FLASH,Color.GREEN)
			Global.float_text(str("+",context["amount"]),target.global_position,Color.GREEN)
			target.update()
	
