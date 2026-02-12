extends Action

#AN ATTACK THAT FORGOES DICE EFFECTS, AWAITING CERTAIN ANIMATIONS AND SOUNDS, TO BE ADDED ONTO PRIMARY ATTACKS FOR IMPALE, CLEAVE, ETC

var action_name := "attack"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	var target = context["target"]
	await target.take_attack(context["amount"])
	
