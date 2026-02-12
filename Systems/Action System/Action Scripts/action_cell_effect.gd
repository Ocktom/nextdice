extends Action

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	print ("setting spell effect from action script")
	
	var cells_with_no_effect : Array[Cell] = []
	for x in Global.grid.get_empty_cells():
		if x.cell_effect == Enums.CellEffect.NONE: 
			cells_with_no_effect.append(x)
	
	if cells_with_no_effect.size() < 1:
		return "all cells have effect already"
	
	var cell_pick = cells_with_no_effect.pick_random()
	var effect = Enums.CellEffect[context["cell_effect"]]
	cell_pick.cell_effect = effect
	cell_pick.update()
