extends Action

var action_name := "enemy_pull_attack"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	print ("pull attack action running")
	
	
	if Global.grid.has_straight_path(action_source_cell,Global.hero_unit.current_cell,4,false,true):
		print ("grid has straigght path")
		
		var direction = Global.grid.get_cell_direction(action_source_cell,Global.hero_unit.current_cell)
		var adjacent_cell = Global.grid.get_cells_in_direction(action_source_cell,direction,1)[0]
		
		print ("direction is ", direction, " adjacent_cell is ", adjacent_cell)
		
		print ("pulling hero from", Global.hero_unit.current_cell.cell_vector, " to ", adjacent_cell.cell_vector)
		
		await Global.action_manager.request_action("move_unit",{},Global.hero_unit.current_cell,adjacent_cell)
		await Global.action_manager.request_action("damage_unit",{"amount" : 3,"damage_name" : "PHYSICAL"},action_source_cell,Global.hero_unit.current_cell)
