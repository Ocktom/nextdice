extends Object_Unit
class_name Chest

@onready var hp_label: Label = $Right_Stats/HBoxContainer/HP_Label
@onready var shield_label: Label = $Right_Stats/HBoxContainer/SHIELD_Label

var hp : int = 1
var max_hp : int = 1

var acted_this_turn := false
		
func update():
	
	hp_label.text = str(hp)

func open_chest():
	unit_sprite.play()
	Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNMisc_MOVEMENT-Retro Jump_HY_PC-005.wav"
)
	await Global.timer(1)
	await Global.action_manager.request_action("remove_unit",{},current_cell,current_cell)
	Global.world.find_gear()

func take_damage(amount : int):
	await current_cell.clear_cell()
	queue_free()
