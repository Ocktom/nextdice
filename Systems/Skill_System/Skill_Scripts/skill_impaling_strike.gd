extends Skill

var range = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source_cell: Node, action_target_cell: Node, context:= {}):
	
	var amount := PlayerStats.player_str
	var impale_cell = Global.grid.get_impale_target(Global.hero_unit.current_cell,action_target_cell)
	
	await ActionManager.request_action("attack",{"amount" : amount, "target" : action_target_cell.occupant},Global.hero_unit,action_target_cell)
	
	if impale_cell != null:
		if impale_cell.occupant != null:
			await Global.timer(.3)
			await ActionManager.request_action("damage_unit",
			{"target" : impale_cell, "amount" : amount, "damage_name" : "physical", "audio_path" : "res://Audio/Sound_Effects/DSGNMisc_HIT-Zap Metal_HY_PC-001.wav"},\
			Global.hero_unit,impale_cell)
