extends Action

func execute(context: Dictionary, action_source: Node = null,action_target: Node = null):
	var empty_cells = Global.grid.get_empty_cells()
	if empty_cells.size() < 1 : 
		print ("no empty spaces to spawn")
		return
	else:
		var cell_pick = empty_cells.pick_random()
		var unit_pick = context["unit"]
		await UnitManager.spawn_new_enemy(unit_pick,cell_pick)
