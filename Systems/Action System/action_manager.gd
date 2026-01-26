extends Node

func destroy_enemy(unit : Unit):
	unit.current_cell.clear_cell()
	unit.queue_free()
	Global.world.victory_check()

func request_action(action_name: String, context_dictionary : Dictionary):
	create_action(action_name, context_dictionary)
		
func heal_unit(unit : Unit, amount : int):
	unit.hp = max(unit.max_hp, unit.hp + amount)
	Global.animate(unit, Enums.Anim.FLASH,Color.GREEN_YELLOW)
	Global.float_text(str("+ ", amount),unit.global_position,Color.GREEN)
	unit.update_visuals()
	await Global.timer(.1)

func empower_unit(unit : Unit, amount : int):
	unit.turn_bonus += amount

func create_action(action_name : String, context_dictionary: Dictionary):
	var script_path = str("res://Systems/Action System/Action Scripts/action_", action_name, ".gd")
	var action = Action.new()
	action.set_script(load(script_path))
	action.execute()
