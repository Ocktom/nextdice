extends Action

var action_name := "attack"

func execute(context: Dictionary, action_source: Node = null):
	
	var user = action_source
	var target = context["target"]
	
	await target.take_attack(context["amount"])
	PassiveManager.unit_attacked.emit(target,self)
	PassiveManager.enemy_attacked.emit(target)
