extends Skill

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source_cell: Cell, action_target_cell: Cell, context_dict : Dictionary = {}):
	
	await Global.action_manager.request_action("attack",{"amount" : skill_value},action_source_cell,action_target_cell)
	await Global.timer(.3)
	
	if Global.game_state != Enums.GameState.ROUND_END:
		await Global.action_manager.request_action("shield_unit",{"amount" : skill_value},action_source_cell,action_source_cell)
