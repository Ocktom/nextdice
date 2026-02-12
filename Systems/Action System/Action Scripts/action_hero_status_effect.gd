extends Action

var action_name := "hero_status_effect"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	var target = Global.hero_unit
	
	var color = context["color"]
	var status_name = context["status_name"].to_lower()
	var amount = max(1,context["amount"])
	var status = Enums.Status[context["status_name"]]
	
	if target.status_effects.keys().has(status_name):
		target.status_effects[status_name] = max(amount, target.status_effects[status_name]+amount)
	else:
		target.status_effects[status_name] = amount
	
	print ("the amount of ", status_name, " in ", target.unit_name, "'s status dictionary is ", target.status_effects[status_name])
	
	Global.float_text(str(status_name),target.global_position,Color.WHITE)
	
	target.update()
	
