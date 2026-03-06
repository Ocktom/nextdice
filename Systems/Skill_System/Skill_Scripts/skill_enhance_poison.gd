extends Skill

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source_cell: Cell, action_target_cell: Cell, context_dict : Dictionary = {}):
	Global.action_manager.request_action("add_bonus",{"type" : "poison_damage", "sub_type" : "round_bonus", "amount" : Global.player_stats.player_int/2})
