extends Skill

var range := 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source: Node, action_target: Node, context:= {}):
		await ActionManager.request_action("projectile_attack",{"projectile_name" : "fireball", "amount" : PlayerStats.player_int},Global.hero_unit,action_target)
		await Global.timer(Global.projectile_time)
		await Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNMisc_SKILL RELEASE-Mecha Laser Release_HY_PC-004.wav")
		await ActionManager.request_action("damage_unit",{"amount" : PlayerStats.player_int/2,"damage_name" : "fire"},action_source,action_target)
