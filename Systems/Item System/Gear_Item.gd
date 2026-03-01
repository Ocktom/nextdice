extends Control

@onready var gear_sprite: Sprite2D = $Control/Gear_Sprite
@onready var gear_name_label: Label = $Gear_Name_Label
@onready var button_area: Area2D = $Button_Area
@onready var take_button: Button = $"../../HBoxContainer/Take_Button"
@onready var skip_button: Button = $"../../HBoxContainer/Skip_Button"

# Called when the node enters the scene tree for the first time.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setup_gear(gear_name: String):

	var gear_data = GearManager.gear_data_dictionary[gear_name]
	gear_name_label.text = gear_name
	gear_sprite.texture = load(str("res://Art/Gear_Sprites/",gear_name,".png"))
	
