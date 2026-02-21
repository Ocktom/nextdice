extends Unit
class_name Chest

@onready var unit_sprite: AnimatedSprite2D = $Unit_Sprite
@onready var hp_label: Label = $Right_Stats/HBoxContainer/HP_Label
@onready var shield_label: Label = $Right_Stats/HBoxContainer/SHIELD_Label

var hp : int
var max_hp : int

var acted_this_turn := false
		
func update():
	
	hp_label.text = str(hp)

func open_chest():
	unit_sprite.play()
	Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNMisc_MOVEMENT-Retro Jump_HY_PC-005.wav"
)
	await Global.timer(1)
	Global.world.reward()

func take_damage(amount : int):
	await current_cell.clear_cell()
	queue_free()
