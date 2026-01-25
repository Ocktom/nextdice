extends Node

func destroy_enemy(unit : Unit):
	unit.current_cell.clear_cell()
	unit.queue_free()
	Global.world.victory_check()
