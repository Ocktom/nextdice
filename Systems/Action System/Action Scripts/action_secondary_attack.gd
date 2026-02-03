extends Action

#AN ATTACK THAT FORGOES DICE EFFECTS, AWAITING CERTAIN ANIMATIONS AND SOUNDS, TO BE ADDED ONTO PRIMARY ATTACKS FOR IMPALE, CLEAVE, ETC

var action_name := "attack"

func execute(context: Dictionary, action_source: Node = null,action_target: Node = null):
	
	var user = action_source
	var target = context["target"]

	await target.take_attack(context["amount"])
	SignalBus.unit_attacked.emit(target,self)
	SignalBus.enemy_attacked.emit(target)
	
