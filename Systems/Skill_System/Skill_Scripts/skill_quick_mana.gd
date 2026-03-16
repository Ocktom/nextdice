extends Skill

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source_cell: Cell, action_target_cell: Cell, context:= {}):
	print ("quick_mana being used, skill value is ", skill_value)
	
	Global.action_manager.request_action("gain_mana",{"amount" : skill_value},action_source_cell,action_target_cell)
