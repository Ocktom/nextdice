extends Action

var action_name := "destroy_object"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	
	print ("destroy_object script ran")
	var target = action_target_cell.occupant
	
	if target.dying_this_turn : 
		print ("unit ", target.unit_name, " already dying this turn, exiting out of action_death script ")
		return
	
	target.dying_this_turn = true
	
	UnitManager.dead_units.append(target)
	
	target.effects_sprite.visible = true
	target.effects_sprite.play()
	await Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNImpt_EXPLOSION-Mana Bomb_HY_PC-002.wav")
	target.unit_sprite.visible = false
	#target.status_bar.visible = false

	await Global.timer(.6)
	
	if not is_instance_valid(target):
		return
	
	await target.current_cell.clear_cell()
	
	if target is Bomb:
		await ActionManager.request_action("explosion",{},action_source_cell,action_target_cell)
	
	await UnitManager.clear_dead_units()
	
		
