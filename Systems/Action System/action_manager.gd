extends Node

func destroy_enemy(unit : Unit):
	
	unit.current_cell.clear_cell()
	unit.queue_free()
	Global.world.victory_check()

func request_action(action_name: String, context_dictionary : Dictionary, action_source_cell: Cell = null, action_target_cell : Cell = null):
	
	if Global.game_state == Enums.GameState.PLAYER_TURN:
		InputManager.input_paused = true
	create_action(action_name, context_dictionary, action_source_cell, action_target_cell)

func create_action(action_name : String, context_dictionary: Dictionary, action_source_cell : Cell, action_target_cell: Cell):
	
	var script_path = str("res://Systems/Action System/Action Scripts/action_", action_name, ".gd")
	print ("loading path script", script_path)
	var action = Action.new()
	action.set_script(load(script_path))
	await action.execute(context_dictionary, action_source_cell, action_target_cell)
	
	if Global.game_state == Enums.GameState.PLAYER_TURN:
		InputManager.input_paused = false
	
