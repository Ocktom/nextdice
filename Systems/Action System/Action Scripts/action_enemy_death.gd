extends Action

var action_name := "enemy_death"

func execute(context: Dictionary, action_source: Node = null,action_target: Node = null):
	print ("enemy death executed")
	var target = action_source
	
	
	target.effects_sprite.visible = true
	target.effects_sprite.play()
	await Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNImpt_EXPLOSION-Mana Bomb_HY_PC-002.wav")
	target.unit_sprite.visible = false
	await Global.timer(.6)
	
	
	
	await target.current_cell.clear_cell()
	target.queue_free()
	SignalBus.enemy_death.emit()
	Global.world.victory_check()
