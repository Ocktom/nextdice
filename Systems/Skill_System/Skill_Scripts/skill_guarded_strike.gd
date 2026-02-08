extends Skill

var range = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source: Node, action_target: Node, context_dict : Dictionary = {}):
	
	action_target = action_target.occupant
	
	await ActionManager.request_action("attack",{"amount" : PlayerStats.player_str/2, "target" : action_target},Global.hero_unit,Global.hero_unit)
	await ActionManager.request_action("shield_unit",{"amount" : PlayerStats.player_str/2},Global.hero_unit,Global.hero_unit)
