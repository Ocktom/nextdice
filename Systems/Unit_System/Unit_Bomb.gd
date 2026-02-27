extends Unit
class_name Bomb

@onready var unit_sprite: AnimatedSprite2D = $Unit_Sprite
@onready var hp_label: Label = $Right_Stats/HBoxContainer/HP_Label
@onready var shield_label: Label = $Right_Stats/HBoxContainer/SHIELD_Label

var hp : int
var max_hp : int

var acted_this_turn := false
		
func update():
	
	hp_label.text = str(hp)

func take_damage(amount : int):
	await current_cell.clear_cell()
	queue_free()
