extends Action

var action_name := "shield_unit"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	var amount = max(1,context["amount"])
	var status_name = "shield"
	
	if action_target_cell.occupant.status_effects.keys().has(status_name):
		action_target_cell.occupant.status_effects[status_name] = max(amount, action_target_cell.occupant.status_effects[status_name]+amount)
	else:
		action_target_cell.occupant.status_effects[status_name] = amount
	
	print ("the amount of ", status_name, " in ", action_target_cell.occupant.unit_name, "'s status dictionary is ", action_target_cell.occupant.status_effects[status_name])
	
	Global.float_text(str(status_name, " +",amount),action_target_cell.occupant.global_position,Color.WHITE)
	
	action_target_cell.occupant.update()
	Global.animate(action_target_cell.occupant,Enums.Anim.FLASH,Color.GREEN)
	Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNMisc_HIT-Spell Hit_HY_PC-001.wav")
	Global.float_text("SHIELD",action_target_cell.occupant.global_position,Color.GREEN)
	action_target_cell.occupant.update()
