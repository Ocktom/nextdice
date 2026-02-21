extends Skill

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source_cell: Cell, action_target_cell: Cell, context_dict : Dictionary = {}):
	
	#NEED REFERENCE TO UNIT, FOR USE AFTER IT MOVES
	var unit = action_source_cell.occupant
	
	await ActionManager.request_action("move_unit",{},action_source_cell,action_target_cell)
	await ActionManager.request_action("shield_unit",{"amount" : PlayerStats.player_dex/2},unit.current_cell,unit.current_cell)
	
