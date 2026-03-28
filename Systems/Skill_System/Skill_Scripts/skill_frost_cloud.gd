extends Skill

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source_cell: Cell, action_target_cell: Cell, context:= {}):
	
	
	var cells_effected = Global.grid.get_adjacent_cells(action_target_cell,true)
	cells_effected.append(action_target_cell)
	for x in cells_effected:		
		await Global.action_manager.request_action("cell_effect",{"effect_name" : "SNOW"},x,x)
