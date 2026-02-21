extends Action

func execute(context: Dictionary, action_source_cell: Cell = null,action_target_cell: Cell = null):
	
	var cell_pick: Cell
	var unit_pick: String
	
	if action_target_cell == null:
		var empty_cells = Global.grid.get_empty_cells()
		if empty_cells.size() < 1 : 
			print ("no empty spaces to spawn")
			return
		else:
			cell_pick = empty_cells.pick_random()
	else:
		cell_pick = action_target_cell
	
	unit_pick = context["unit_name"]
	await UnitManager.spawn_new_enemy(unit_pick,cell_pick)
