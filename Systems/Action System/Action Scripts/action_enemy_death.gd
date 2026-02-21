extends Action

var action_name := "enemy_death"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	print ("enemy death executed")
	var target = action_source_cell.occupant
	
	target.effects_sprite.visible = true
	target.effects_sprite.play()
	await Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNImpt_EXPLOSION-Mana Bomb_HY_PC-002.wav")
	target.unit_sprite.visible = false
	target.status_bar.visible = false
	
	var gold_reward = randi_range(1,3)
	ActionManager.request_action("gain_gold",{"amount" : gold_reward},null,null)
	
	await Global.timer(.6)
	
	if not is_instance_valid(target):
		return
	
	await target.current_cell.clear_cell()
	
	await EventManager.on_enemy_death(target)
	
	target.queue_free()
	await Global.world.victory_check()
