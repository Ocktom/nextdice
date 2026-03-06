extends Action

var action_name := "explosion"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNImpt_EXPLOSION-Sand Impact_HY_PC-005.wav")
	
	print ("explosion running")
	
	var adjacent_cells = Global.grid.get_adjacent_cells(action_target_cell,true)
	var explosion_cells = adjacent_cells.duplicate()
	explosion_cells.append(action_target_cell)
	
	for x in explosion_cells:
		x.cell_animation.sprite_frames = load("res://Art/Cell_Effect_Sprites/explosion_frames.tres")
		x.cell_animation.visible = true
		x.cell_animation.play()
	await Global.timer(.3)
	
	for x in explosion_cells:
		x.cell_animation.stop()
		x.cell_animation.visible = false
	
	for x in adjacent_cells:
		if not x.is_empty():
			if not Global.game_state == Enums.GameState.ROUND_END:
				await Global.action_manager.request_action("damage_unit",{"amount" : 3,"damage_name" : "physical"},action_source_cell,x)
