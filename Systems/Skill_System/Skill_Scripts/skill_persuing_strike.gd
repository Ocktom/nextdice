extends Skill

var range = PlayerStats.move_points/2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source: Node, action_target: Node, context:= {}):
	
	await ActionManager.request_action("move_unit",{},Global.hero_unit,action_target)
	var adjacent_units = Global.grid.get_adjacent_units(action_source.current_cell)
	for x in adjacent_units:
		await Global.timer(.25)
		ActionManager.request_action("attack",{"target" : x, "amount" : PlayerStats.player_str/2, "sound_path" : "res://Audio/Sound_Effects/DSGNTonl_INTERFACE-Tonal Click_HY_PC-006.wav"},action_source,x)
		
