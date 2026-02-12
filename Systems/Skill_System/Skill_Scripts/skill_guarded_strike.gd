extends Skill

var range = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source_cell: Cell, action_target_cell: Cell, context_dict : Dictionary = {}):
	
	await ActionManager.request_action("attack",{"amount" : PlayerStats.player_str/2},action_source_cell,action_target_cell)
	await Global.timer(.3)
	await ActionManager.request_action("shield_unit",{"amount" : PlayerStats.player_str/2},action_source_cell,action_source_cell)
