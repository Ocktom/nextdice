extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
		
		var status_name = context["status_name"]
		var target_cells : Array [Cell]
				
		var adjacent_units : Array[Unit]
		for x in Global.grid.get_adjacent_units(action_source_cell):
			if x is Enemy: 
				target_cells.append(x.current_cell)
		
		for x in target_cells:
			await Global.action_manager.request_action("status_effect",{"status_name": status_name,"amount" : context["amount"]},
			action_source_cell,x)
