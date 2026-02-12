extends Passive

var passive_value := 2

func set_trigger():
	print ("setting trigger for spikes")

func _on_triggered(target : Unit, attacker: Unit):
	
	print ("spikes triggered")
	if target == source:
		ActionManager.request_action("damage_unit",{"damage_name": "physical","amount": passive_value},source,attacker)
