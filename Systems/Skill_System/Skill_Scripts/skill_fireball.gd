extends Skill

var range := 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source_cell: Cell, action_target_cell: Cell, context:= {}):
		await ActionManager.request_action("projectile_attack",{"projectile_name" : "fireball", "amount" : PlayerStats.player_int},action_source_cell,action_target_cell)
		Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNMisc_SKILL RELEASE-Mecha Laser Release_HY_PC-004.wav")
		await Global.timer(Global.projectile_time)
		await ActionManager.request_action("damage_unit",{"amount" : PlayerStats.player_int/2,"damage_name" : "fire"},action_source_cell,action_target_cell)
		if action_target_cell.cell_effect == Enums.CellEffect.GRASS:
			action_target_cell.cell_effect = Enums.CellEffect.FIRE
			action_target_cell.update()
