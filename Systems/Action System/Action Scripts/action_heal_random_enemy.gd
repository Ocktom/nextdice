extends Action

var action_name := "heal_random_enemy"

func execute(context: Dictionary, action_source: Node = null):
	
	var user = action_source
	
	var damaged_enemies : Array[Enemy] = []
	for x in Global.grid.get_all_enemies():
		if not is_instance_valid(x):
			return
		if x.hp < x.max_hp:
			damaged_enemies.append(x)
	
	var x = damaged_enemies.pick_random()
	x.occupant.hp = min(x.occupant.max_hp, x.occupant.hp + context["amount"])
	Global.animate(x,Enums.Anim.FLASH,Color.GREEN)
	Global.float_text(str("+",context["amount"]),x.occupant.global_position,Color.GREEN)
	x.occupant.update()
