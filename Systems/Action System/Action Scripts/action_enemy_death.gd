extends Action

var action_name := "enemy_death"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	print (" death executed")
	var target = action_source_cell.occupant
	
	if target.dying_this_turn : 
		print ("unit ", target.unit_name, " already dying this turn, exiting out of action_death script ")
		return
	
	target.dying_this_turn = true
	
	Global.unit_manager.dead_units.append(target)
	
	target.effects_sprite.visible = true
	target.effects_sprite.play()
	await Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNImpt_EXPLOSION-Mana Bomb_HY_PC-002.wav")
	target.unit_sprite.visible = false
	target.status_bar.visible = false
	target.right_stats.visible = false
	
	var gold_reward = randi_range(1,3)
	Global.action_manager.request_action("gain_gold",{"amount" : gold_reward},null,null)
	
	await Global.timer(.3)
	
	if not is_instance_valid(target):
		return
	
	await target.current_cell.clear_cell()
	await Global.event_manager.on_enemy_death(target)
	await Global.unit_manager.clear_dead_units()
	await Global.world.victory_check()
