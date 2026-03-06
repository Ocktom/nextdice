extends Action

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	var former_unit = action_source_cell.occupant
	await action_target_cell.clear_cell()
	former_unit.queue_free()
	
	var unit_pick = context["unit_name"]
	
	await Global.unit_manager.spawn_new_enemy(unit_pick,action_target_cell)
