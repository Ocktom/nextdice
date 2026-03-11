extends Action

var action_name := "damage"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	print ("running action_damage_unit script on ", action_target_cell.occupant)
	
	#CONTEXT: damage_name, amount, audio_path (optional)
	
	var action_target = action_target_cell.occupant
	
	if not is_instance_valid(action_target):
		return
	if action_target.dying_this_turn:
		return
	
	var target_status_effects : Dictionary
	
	var audio_path : String = ""
	var color : Color
	var amount = context["amount"]
	
	if action_target is Hero:
		target_status_effects = Global.player_stats.status_effects
	else:
		target_status_effects = action_target.status_effects
	
	#APPLY SHIELD
	
	if context["damage_name"] == "physical":
		if target_status_effects.has("shield"):
			var shield = target_status_effects["shield"]
		
			if amount <= shield:
				print ("damage was shielded")
				target_status_effects["shield"] -= amount
				#action_target.play_sprite_anim(Enums.Anim.SHAKE)
				#action_target.play_sprite_anim(Enums.Anim.FLASH)
				Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNMisc_HIT-Spell Hit_HY_PC-001.wav")
				Global.float_text("SHIELDED",action_target_cell.global_position,Color.GAINSBORO)
				await action_target_cell.occupant.update()
				return
			
			if amount > shield:
				print ("damage broke shield, remaining damage is ", amount)
				amount -= shield
	
	match context["damage_name"]:
		
		"poison" : 
			print ("poison damage matched, amount is ", amount)
			color = Color.GREEN
			amount += Global.player_stats.poison_damage["round_bonus"] 
			+ Global.player_stats.poison_damage["turn_bonus"]
			
			if action_target is Object_Unit:
				print ("action is object, returning")
				return
			
		"fire"	:
			audio_path = "res://Audio/Sound_Effects/DSGNMisc_HIT-Fleeting Hit_HY_PC-005.wav"
			color = Color.ORANGE
			amount += Global.player_stats.fire_damage["round_bonus"] 
			+ Global.player_stats.fire_damage["turn_bonus"]
			
		"physical" :
			color = Color.RED
			amount += (Global.player_stats.physical_damage["round_bonus"])
			+ (Global.player_stats.physical_damage["turn_bonus"])	
		
		"magic" :
			color = Color.DODGER_BLUE
			if action_source_cell.occupant is Hero and action_target is Enemy:
				amount += Global.player_stats.magic_damage["round_bonus"] 
				+ Global.player_stats.magic_damage["turn_bonus"]	
	
	Global.float_text(str(amount),action_target.global_position,color)
	
	if context.keys().has("audio_path"):
		audio_path = context["audio_path"]
	
	if audio_path != "":
		Global.audio_node.play_sfx(audio_path)
	
	action_target.flash_sprite(color)
	action_target.shake_sprite()
	
	if action_target is Enemy:
			
			await Global.event_manager.on_unit_damaged(action_target,amount,context["damage_name"])
			
			action_target.hp = max(0,action_target.hp-amount)
			
			if action_target.hp < 1:
				
				print ("unit has less then 1 hp, calling enemy death on manager")
				await Global.action_manager.request_action("enemy_death",{},action_target.current_cell)
		
	if action_target is Hero:
		Global.player_stats.player_hp = max(0,Global.player_stats.player_hp-amount)
		await action_target.update()
		
		if Global.player_stats.player_hp < 1:
			print ("player died")
			await Global.action_manager.request_action("hero_death",{},action_target.current_cell)
		
		else:
			await action_target.update()
	
	if action_target is Object_Unit:
		action_target.hp = max(0,action_target.hp-amount)
		print ("object unit damaged")
		
		await action_target.update()
		
		if action_target.hp < 1:
			
			print ("object unit hp is 0")
			if not action_target.dying_this_turn:
				await Global.action_manager.request_action("destroy_object",{},action_source_cell,action_target_cell)
	
