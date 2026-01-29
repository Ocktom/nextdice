extends Passive

func set_trigger():
	print ("enrage trigger set on ", source.unit_name)
	SignalBus.connect("enemy_attacked",_on_triggered)

func _on_triggered(unit_damaged : Unit):
	
	if not is_instance_valid(source):
		return
	
	if source.hp < 1:
		return
	
	if unit_damaged == source:
		unit_damaged.status_effects["invisible"] = 1
		await Global.timer(.5)
		Global.float_text("INVISIBLE",source.global_position,Color.WHITE)
		Global.animate(source,Enums.Anim.FLASH,Color.WHITE)
		source.update()
		await Global.timer(.5)
