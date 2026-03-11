extends Skill

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source_cell: Cell, action_target_cell: Cell, context:= {}):
	print ("strike being used")
	
	var adjacent_enemies = Global.grid.get_adjacent_enemies(Global.hero_unit.current_cell)
	if adjacent_enemies.size() > 0:
		var enemy_pick = adjacent_enemies.pick_random()
		Global.action_manager.request_action("attack",{"amount" : Global.player_stats.player_str},action_source_cell,enemy_pick.current_cell)
