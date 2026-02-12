extends Action

var action_name := "increase_attack_self"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	print ("executing action script of ", action_name, " with context ", context)
	
	if action_source_cell.occupant.atk > 1: 
		action_source_cell.occupant.atk += context["amount"]
		Global.animate(action_source_cell.occupant,Enums.Anim.FLASH,Color.ORANGE_RED)
		Global.float_text(str("+",context["amount"], " ATK"),action_source_cell.occupant.global_position,Color.ORANGE_RED)
		action_source_cell.occupant.update()
		await Global.timer(.5)
