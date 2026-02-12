extends Action

var action_name := "damage"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	#CONTEXT: damage_name, amount, audio_path (optional)
	
	print ("excecuting action_damage_unit")
	var action_target = action_target_cell.occupant
	
	var user = action_source_cell.occupant
	var audio_path : String = ""
	var color : Color
	
	match context["damage_name"]:
		"poison" : 
			color = Color.GREEN
			Global.float_text("Poison",action_target.global_position,color)
			
		"fire"	:
			audio_path = "res://Audio/Sound_Effects/DSGNMisc_HIT-Fleeting Hit_HY_PC-005.wav"
			color = Color.ORANGE
			Global.float_text("Burn",action_target.global_position,color)
		
		"physical" :
			color = Color.RED
			Global.float_text(str(context["amount"]),action_target.global_position,color)
	
	if context.keys().has("audio_path"):
		audio_path = context["audio_path"]
	
	if audio_path != "":
		Global.audio_node.play_sfx(audio_path)
	Global.animate(action_target,Enums.Anim.SHAKE)
	Global.animate(action_target,Enums.Anim.FLASH,color)
	action_target.take_damage(context["amount"])
	
	
	await Global.timer(.4)
