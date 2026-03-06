extends Action

var action_name := "enemy_move"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	print ("enemy_move action ran")
	await Global.enemy_manager.attempt_move(action_source_cell.occupant)
