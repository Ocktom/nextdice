extends Action

var action_name := "status_effect"

func execute(context: Dictionary, action_source_cell: Cell = null, target_cell: Cell = null):
	
	var status_effects : Dictionary
	if target_cell.occupant is Hero:
		status_effects = PlayerStats.status_effects
	else:
		status_effects = target_cell.occupant.status_effects
	
	var target = target_cell.occupant
	var color : Color
	var status_name = context["status_name"].to_lower()
	var amount = max(1,context["amount"])
	var status = Enums.Status[context["status_name"]]
	
	match status_name:
		
		"poison" : color = Color.LIME_GREEN
		"burn" : color = Color.ORANGE
		
		"frost" : 
			color = Color.POWDER_BLUE
			if target_cell.occupant.status_effects.has("freeze"):
				return
		
		"freeze" : color = Color.POWDER_BLUE
		"stun" : color = Color.WHITE
		"root" : color = Color.NAVAJO_WHITE
		"shield" : color = Color.GAINSBORO
	
	if status_effects.keys().has(status_name):
		status_effects[status_name] = max(amount, status_effects[status_name]+amount)
	else:
		status_effects[status_name] = amount
	
	print ("the amount of ", status_name, " in ", target.unit_name, "'s status dictionary is ", status_effects[status_name])
	
	Global.animate(target_cell.occupant,Enums.Anim.FLASH,color)
	Global.float_text(str(status_name, " +",amount),target.global_position,Color.WHITE)
	
	await target.update()
	
