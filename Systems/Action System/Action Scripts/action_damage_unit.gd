extends Action

var action_name := "damage"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	#CONTEXT: damage_name, amount, audio_path (optional)
	
	var action_target = action_target_cell.occupant
	
	if not is_instance_valid(action_target):
		return
	if action_target.dying_this_turn:
		return
	
	var target_status_effects : Dictionary
	
	var user = action_source_cell.occupant
	var audio_path : String = ""
	var color : Color
	var amount = context["amount"]
	
	if action_target is Hero:
		target_status_effects = PlayerStats.status_effects
	else:
		target_status_effects = action_target.status_effects
	
	#APPLY SHIELD
	
	if context["damage_name"] == "physical":
		if target_status_effects.has("shield"):
			var shield = target_status_effects["shield"]
		
			if amount <= shield:
				print ("damage was shielded")
				target_status_effects["shield"] -= amount
				Global.animate(action_target,Enums.Anim.SHAKE)
				Global.animate(action_target,Enums.Anim.FLASH)
				Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNMisc_HIT-Spell Hit_HY_PC-001.wav")
				Global.float_text("SHIELDED",action_target_cell.global_position,Color.GAINSBORO)
				await action_target_cell.occupant.update()
				return
			
			if amount > shield:
				print ("damage broke shield, remaining damage is ", amount)
				amount -= shield
	
	match context["damage_name"]:
		
		"poison" : 
			color = Color.GREEN
			amount += PlayerStats.poison_damage["round_bonus"] 
			+ PlayerStats.poison_damage["turn_bonus"]
			
		"fire"	:
			audio_path = "res://Audio/Sound_Effects/DSGNMisc_HIT-Fleeting Hit_HY_PC-005.wav"
			color = Color.ORANGE
			amount += PlayerStats.fire_damage["round_bonus"] 
			+ PlayerStats.fire_damage["turn_bonus"]
			
		"physical" :
			color = Color.RED
			amount += (PlayerStats.physical_damage["round_bonus"])
			+ (PlayerStats.physical_damage["turn_bonus"])	
		
		"magic" :
			color = Color.DODGER_BLUE
			if action_source_cell.occupant is Hero and action_target is Enemy:
				amount += PlayerStats.magic_damage["round_bonus"] 
				+ PlayerStats.magic_damage["turn_bonus"]	
	
	Global.float_text(str(context["damage_name"],": ",amount),action_target.global_position,color)
	
	if context.keys().has("audio_path"):
		audio_path = context["audio_path"]
	
	if audio_path != "":
		Global.audio_node.play_sfx(audio_path)
	Global.animate(action_target,Enums.Anim.SHAKE)
	Global.animate(action_target,Enums.Anim.FLASH,color)
	
	await action_target.take_damage(amount)
	
	await Global.timer(.4)
	
	print ("calling unit_damaged...")
	await EventManager.on_unit_damaged(action_target, amount, context["damage_name"])
