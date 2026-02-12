extends Skill

var range = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source: Node, action_target: Node, context:= {}):
	print ("kick being used")
	
	action_target = action_target.occupant
	
	ActionManager.request_action("push_unit",{},action_source.current_cell,action_target)
