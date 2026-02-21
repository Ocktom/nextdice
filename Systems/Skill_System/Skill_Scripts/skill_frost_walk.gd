extends Skill

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source_cell: Cell, action_target_cell: Cell, context:= {}):
	
	#UNIT REF FOR AFTER MOVE
	var unit = action_source_cell.occupant
	
	var cells_passed = Global.grid.get_cells_in_path(Global.hero_unit.current_cell,action_target_cell)
	await ActionManager.request_action("move_unit",{},Global.hero_unit.current_cell,action_target_cell)
	
	cells_passed.erase(Global.hero_unit.current_cell)
	
	for x in cells_passed:
		
		await Global.timer(.04)
		await ActionManager.request_action("cell_effect",
		{"cell_effect" : "SNOW"},unit.current_cell,x)
