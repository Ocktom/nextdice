extends Action

var action_name := "enemy_pull_attack"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	print ("action throw_web running")
	
	if action_source_cell.occupant is Enemy:
		
		var adjacents = Global.grid.get_adjacent_cells(Global.hero_unit.current_cell)
		var empty_adjacents : Array[Cell] = []
		for x in adjacents:
			if x.is_empty():
				empty_adjacents.append(x)
		
		if empty_adjacents.size() > 0:
			action_target_cell = empty_adjacents.pick_random()
		
		else:
			action_target_cell = null
	
		if action_target_cell == null:
			action_target_cell = Global.grid.get_empty_cells().pick_random()
	
		await Global.action_manager.request_action("cell_effect",{"effect_name" : "WEB"},action_source_cell,action_target_cell)
