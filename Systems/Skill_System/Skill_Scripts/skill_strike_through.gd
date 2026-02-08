extends Skill

var range = PlayerStats.move_points + 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source: Node, action_target: Node, context:= {}):
	
	var units_passed = Global.grid.get_units_in_path(Global.hero_unit.current_cell,action_target)
	await ActionManager.request_action("move_unit",{},Global.hero_unit,action_target)
	for x in units_passed:
		await Global.timer(.04)
		await ActionManager.request_action("damage_unit",
		{"damage_name" : "physical","amount" : PlayerStats.player_dex/2, "audio_path" : "res://Audio/Sound_Effects/DSGNMisc_HIT-Zap Metal_HY_PC-002.wav"},
		action_source,x.current_cell)
