extends Action

var action_name := "destroy_object"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	
	print ("remove_unit script ran")
	var target = action_target_cell.occupant

	target.unit_sprite.visible = false
	
	if not is_instance_valid(target):
		return
	
	target.queue_free()
	await action_target_cell.clear_cell()
		
