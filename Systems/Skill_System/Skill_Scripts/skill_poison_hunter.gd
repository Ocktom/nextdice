extends Skill

var range := 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source_cell: Cell, action_target_cell: Cell, context:= {}):
	
	var hunted_enemies = Global.grid.get_enemies_with_status("poison")
	
	if hunted_enemies.size() < 1:
		print ("no valid targets")
		Global.float_text("NO TARGETS", Global.hero_unit.position,Color.WHITE)
		return
	
	for x in hunted_enemies:
		
		if not is_instance_valid(x):
			continue
		if x.dying_this_turn:
			continue
		
		await ActionManager.request_action("projectile_attack",{"projectile_name" : "purple_ball", "amount" : PlayerStats.player_int},action_source_cell,x.current_cell)
		Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNMisc_SKILL RELEASE-Mecha Laser Release_HY_PC-004.wav")
		await Global.timer(Global.projectile_time)
		
		await ActionManager.request_action("damage_unit",{"amount" : PlayerStats.player_int-1,"damage_name" : "magic"},action_source_cell,x.current_cell)
