extends Passive


func set_trigger():
	SignalBus.connect("unit_attacked",_on_triggered)

func _on_triggered(unit_attacked: Unit, unit_attacking: Unit):
	if unit_attacked == source:
		unit_attacking.take_non_attack_damage(2)
