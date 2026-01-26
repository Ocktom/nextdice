extends Action

var action_name := "enemy_death"

func execute(context: Dictionary, action_source: Node = null):
	print ("enemy death executed")
	var target = action_source
	
	await target.current_cell.clear_cell()
	target.queue_free()
	PassiveManager.enemy_death.emit()
