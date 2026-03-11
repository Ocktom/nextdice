extends Action

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	print ("running cell_effect script")
	
	var cell_pick: Cell
	
	if action_target_cell == null:
	
		var cells_with_no_effect : Array[Cell] = []
		for x in Global.grid.get_empty_cells():
			if x.cell_effect == Enums.CellEffect.NONE: 
				cells_with_no_effect.append(x)
	
		if cells_with_no_effect.size() < 1:
			return "all cells have effect already"
		cell_pick = cells_with_no_effect.pick_random()
	
	else:
		cell_pick = action_target_cell
	
	print ("cell_pick in cell_effect script is ", cell_pick)
	print ("action_cell effect context is ", context)
	
	cell_pick.cell_effect = Enums.CellEffect[context["effect_name"]]
	await cell_pick.update()
	
	if cell_pick.occupant != null:
		await Global.event_manager.apply_cell_effects(cell_pick.occupant)
