extends Node

func destroy_enemy(unit : Unit):
	unit.current_cell.clear_cell()
	unit.queue_free()
	Global.world.victory_check()

func request_action(action_name: String, context_dictionary : Dictionary, action_source: Node = null):
	
	InputManager.input_paused = true
	create_action(action_name, context_dictionary, action_source)

func create_action(action_name : String, context_dictionary: Dictionary, action_source : Node = null):
	var script_path = str("res://Systems/Action System/Action Scripts/action_", action_name, ".gd")
	print ("loading path script", script_path)
	var action = Action.new()
	action.set_script(load(script_path))
	await action.execute(context_dictionary, action_source)

	InputManager.input_paused = false
	
