extends Passive

var passive_value := 2

func set_trigger():
	print ("setting trigger for spikes")
	SignalBus.connect("unit_attacked",_on_triggered)

func _on_triggered(target : Unit, attacker: Unit):
	
	print ("spikes triggered")
	if target == source:
		ActionManager.request_action("damage_unit",{"damage_name": "physical","amount": passive_value},source,attacker)
