extends Action

var action_name := "attack"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	print ("executing acttack action, amount is", context["amount"])
	
	var sound_path : String
	
	if action_source_cell.occupant == Global.hero_unit:
		action_source_cell.occupant.unit_sprite.sprite_frames = load("res://Art/warrior_attack_frames.tres")
		action_source_cell.occupant.unit_sprite.play()
		await Global.timer(.26)
	
	if context.keys().has("sound_path"):
		sound_path = context["sound_path"]
	else:
		sound_path = "res://Audio/Sound_Effects/FGHTImpt_HIT-Strong Smack_HY_PC-003.wav"
	
	Global.audio_node.play_sfx(sound_path)
	await Global.animate(action_source_cell.occupant,Enums.Anim.LUNGE,Color.WHITE,action_target_cell)
	
	if action_source_cell.occupant == Global.hero_unit:
		await Global.timer(.1)
		action_source_cell.occupant.unit_sprite.sprite_frames = load("res://Art/warriro_frames.tres")
		action_source_cell.occupant.unit_sprite.play()
	
	await Global.timer(.1)
	
	await action_target_cell.occupant.take_attack(context["amount"],action_source_cell.occupant)
	await EventManager.on_unit_attacked(action_source_cell.occupant,action_target_cell.occupant)
