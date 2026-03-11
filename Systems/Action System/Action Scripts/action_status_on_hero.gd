extends Action

var action_name := "status_on_hero"

func execute(context: Dictionary, action_source_cell: Cell = null, target_cell: Cell = null):
	
	var acting_enemy = action_source_cell.occupant
	
	var can_attack = Global.grid.has_straight_path(action_source_cell, Global.hero_unit.current_cell,acting_enemy.atk_range,acting_enemy.attack_diag,true)
	if not can_attack:
		return
	
	var target = Global.hero_unit
	await Global.action_manager.request_action("status_effect",{"status_name" : "POISON", "amount" : 2},action_source_cell,target.current_cell)
	
