extends Action

var action_name = "add_bonus"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	var amount = context["amount"]
	Global.player_stats.mana = maxi(Global.player_stats.mana - amount, 0)
	await Global.player_ui.update()
	
