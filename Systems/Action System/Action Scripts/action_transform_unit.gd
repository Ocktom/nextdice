extends Action

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	
	action_target_cell.occupant.queue_free()
	action_target_cell.clear_cell()
	
	var unit_pick = context["unit_name"]
	
	await UnitManager.spawn_new_enemy(unit_pick,action_target_cell)
