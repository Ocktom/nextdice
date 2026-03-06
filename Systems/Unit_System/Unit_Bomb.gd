extends Object_Unit
class_name Bomb

@onready var hp_label: Label = $Right_Stats/HBoxContainer/HP_Label
@onready var shield_label: Label = $Right_Stats/HBoxContainer/SHIELD_Label

var hp : int = 1
var max_hp : int = 1

var acted_this_turn := false
		
func update():
	
	hp_label.text = str(hp)
