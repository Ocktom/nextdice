extends Action

var action_name = "add_bonus"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	var amount = context["amount"]
	
	PlayerStats.gold += amount
	await Global.player_ui.update()
