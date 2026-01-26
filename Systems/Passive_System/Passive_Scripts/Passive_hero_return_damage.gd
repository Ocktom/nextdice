extends Passive

var passive_name := "hero_return_damage"
var trigger := Enums.Trigger.HERO_TAKE_DAMAGE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func trigger_passive(context: Dictionary):
	var source = context["source"]
	if source is Enemy:
		ActionManager.actio
