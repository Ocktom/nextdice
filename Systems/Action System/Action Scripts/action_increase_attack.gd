extends Action

var action_name := "increase_attack_self"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	print ("executing action script of ", action_name, " with context ", context)
	
	if action_target_cell.occupant.atk > 0: 
		print ("increasing attack...")
		action_target_cell.occupant.atk += context["amount"]
		Global.animate(action_target_cell.occupant,Enums.Anim.FLASH,Color.ORANGE_RED)
		Global.animate(action_target_cell.occupant,Enums.Anim.POP)
		Global.float_text(str("+",context["amount"], " ATK"),action_target_cell.occupant.global_position,Color.ORANGE_RED)
		action_target_cell.occupant.update()
		await Global.timer(.4)
