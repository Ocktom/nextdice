extends Action

var action_name = "add_bonus"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	var amount = context["amount"]
	var bonus_type = context["type"]
	var bonus_subtype = context["sub_type"]

	PlayerStats[bonus_type][bonus_subtype] += amount
	
	print ("fire_damage round bonus is now", PlayerStats.fire_damage["round_bonus"])
