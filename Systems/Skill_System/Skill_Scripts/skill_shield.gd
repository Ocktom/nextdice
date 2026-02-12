extends Skill

var range = PlayerStats.move_points

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source_cell: Cell, action_target_cell: Cell, context_dict : Dictionary = {}):
	
	await ActionManager.request_action("shield_unit",{"amount" : PlayerStats.player_dex/2},action_source_cell,action_target_cell)
	
