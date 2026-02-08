extends Skill

var range = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source_cell: Node, action_target_cell: Node, context:= {}):
		
		print ("running skill cleaving_strike")
		
		var cleave_cells = Global.grid.get_cleave_targets(Global.hero_unit.current_cell,action_target_cell)
		var occupied_cleave_cells : Array[Cell] = []
		var main_amount := PlayerStats.player_str
		var cleave_amount = PlayerStats.player_str/2
		
		for x in cleave_cells:
			if x.occupant != null:
				print ("appending ", x.occupant, " to cleave_units")
				occupied_cleave_cells.append(x)
		
		await ActionManager.request_action("attack",{"amount" : main_amount, "target" : action_target_cell.occupant},Global.hero_unit,action_target_cell)
		
		for x in occupied_cleave_cells:
			await ActionManager.request_action("damage_unit",{"target" : x, "amount" : cleave_amount, "damage_name" : "physical"},Global.hero_unit,x)
