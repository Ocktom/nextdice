extends Skill

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source_cell: Cell, action_target_cell: Cell, context:= {}):
	
	var direction = Global.grid.get_cell_direction(action_source_cell,action_target_cell)
	var unit_hit = Global.grid.get_obstructing_unit(action_source_cell,direction)
	
	if unit_hit != null:
		var cells_ahead = Global.grid.get_cells_in_direction(action_source_cell,direction,1)
		var closest_cell = cells_ahead[0]
		if unit_hit.current_cell != closest_cell:
			ActionManager.request_action("move_unit",{},unit_hit.current_cell,closest_cell)
	else:
		if action_source_cell != action_target_cell:
			await ActionManager.request_action("move_unit",{},action_source_cell,action_target_cell)
		
