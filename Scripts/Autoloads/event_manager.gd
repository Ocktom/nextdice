extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_unit_damaged(unit_damaged: Unit):
	if unit_damaged.unit_passives.keys().has("enrage"):
		print (unit_damaged.unit_name, " is ENRAGED")
		Global.float_text("ENRAGE", unit_damaged.global_position,Color.RED)
		
