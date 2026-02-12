extends Passive

func set_trigger():
	pass

func _on_triggered(unit_damaged : Unit):
	
	if not is_instance_valid(source):
		return
	
	if source.hp < 1:
		return
	
	if unit_damaged == source:
		await Global.timer(.5)
		Global.float_text("ENRAGED",source.global_position,Color.ORANGE_RED)
		source.atk += 2
		Global.animate(source,Enums.Anim.FLASH,Color.ORANGE_RED)
		source.update()
		await Global.timer(.5)
