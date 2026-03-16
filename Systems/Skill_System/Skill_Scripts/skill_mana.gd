extends Skill

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source: Cell, action_target_cell: Cell, context:= {}):
	await Global.action_manager.request_action("gain_mana",{"amount" : 2},Global.hero_unit.current_cell,Global.hero_unit.current_cell)
