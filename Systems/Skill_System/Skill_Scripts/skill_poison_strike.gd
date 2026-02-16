extends Skill

var range = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source_cell: Cell, action_target_cell: Cell, context:= {}):
	print ("strike being used")
	
	await ActionManager.request_action("attack",{"amount" : PlayerStats.player_str},action_source_cell,action_target_cell)
	if action_target_cell.occupant != null:
		if not action_target_cell.occupant.dying_this_turn:
			await Global.timer(.3)
			await ActionManager.request_action("status_effect",{"amount" : 2,"status_name" : "POISON", "color" : Color.LIME_GREEN},action_source_cell,action_target_cell)
