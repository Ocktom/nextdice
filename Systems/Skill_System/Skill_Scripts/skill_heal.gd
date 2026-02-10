extends Skill

var range = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source: Node, action_target: Node, context_dict : Dictionary = {}):
	print ("heal unit used")
	await ActionManager.request_action("heal_unit",{"amount" : PlayerStats.player_int},Global.hero_unit,Global.hero_unit)
	Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNMisc_MOVEMENT-Retro Jump_HY_PC-001.wav")
