extends Action

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	
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
	
		await Global.unit_manager.spawn_bomb(action_target_cell)
