extends Action

var action_name = "gain_mana"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	var amount = context["amount"]
	
	if Global.player_stats.mana < Global.player_stats.max_mana:
		var new_mana_amount = mini(Global.player_stats.mana + amount, Global.player_stats.max_mana)
		var amount_added = new_mana_amount - Global.player_stats.mana
		Global.float_text(str("+",amount_added),Global.hero_unit.global_position,Color.DEEP_SKY_BLUE)
		Global.player_stats.mana = new_mana_amount
	
	await Global.player_ui.update()
	
