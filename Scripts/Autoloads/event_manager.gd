extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_unit_damaged(unit_damaged: Unit, amount: int, damage_name: String):
	
	print ("on_unit_damage called on unit", unit_damaged.unit_name)
	
	if unit_damaged.status_effects.keys().has("enrage"):
		print (unit_damaged.unit_name, " is ENRAGED")
		Global.float_text("ENRAGE", unit_damaged.global_position,Color.RED)
	 
func on_unit_attacked(attacker: Unit, attacked: Unit):
	if attacked.status_effects.has("spikes"):
		print ("unit has spikes of ", attacked.status_effects["spikes"])
		ActionManager.request_action("damage_unit",
		{"amount" : attacked.status_effects["spikes"],"damage_name" : "physical"},
		attacked.current_cell,attacker.current_cell)

func on_unit_moved(moved_unit: Unit, start_cell: Cell, end_cell: Cell):
	if moved_unit is Hero:
		
		for x in Global.grid.get_all_units():
			if x.status_effects.keys().has("alert"):
				if Global.grid.get_distance(x.current_cell,end_cell) <= x.atk_range:
					if Global.grid.has_clear_path(x.current_cell,end_cell):
						await ActionManager.request_action("attack",{"amount" : x.atk},x.current_cell,end_cell)

func on_enemy_death(enemy_dying: Enemy):
	
	if enemy_dying.status_effects.keys().has("undying"):
		var cell = enemy_dying.current_cell
		cell.clear_cell()
		enemy_dying.visible = false
		await ActionManager.request_action("spawn_unit",{"unit_name" : "ScrapPile"},cell,cell)
	
	if enemy_dying.unit_name == "Roblob":
		for x in 2:
			var cell_pick = Global.grid.get_empty_cells().pick_random()
			await ActionManager.request_action("spawn_unit",{"unit_name" : "Roblobito"},cell_pick,cell_pick)
	
