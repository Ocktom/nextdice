extends Action

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	print ("setting action effect from action script")
	
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
		
	var effect = Enums.CellEffect[context["cell_effect"]]
	
	cell_pick.cell_effect = effect
	if cell_pick.occupant != null:
		await cell_pick.apply_cell_effects_to_unit()
	await cell_pick.update()
