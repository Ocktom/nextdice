extends Passive

func set_trigger():
	print ("scavenge trigger set on ", source.unit_name)

func _on_triggered():
	
	if not is_instance_valid(source):
		return
	
	if source.dying_this_turn:
		return
	
	print ("scavenge trigger proc'd")
	source.hp += 1
	source.atk += 1
	Global.animate(source,Enums.Anim.POP)
	Global.animate(source,Enums.Anim.FLASH)
	Global.float_text("GROW",source.global_position,Color.YELLOW)
	source.update()
