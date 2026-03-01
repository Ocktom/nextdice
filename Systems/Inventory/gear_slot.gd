extends Control
class_name GearSlot

var gear_slot_type : Enums.GearSlotType
var gear_name : String
var full := false
var extending_slot : GearSlot = null

@onready var gear_texture: TextureRect = $gear_texture
@onready var gear_area: Area2D = $Gear_Area

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gear_area.connect("mouse_entered",_on_mouse_entered)
	gear_area.connect("mouse_exited",_on_mouse_exited)

func _process(delta: float) -> void:
	pass

func _on_mouse_entered():
	print ("gear hovered, with gear of", gear_name, " andf of type ", gear_slot_type)
	if extending_slot != null:
		InputManager.hovered_gear = extending_slot
	else:
		InputManager.hovered_gear = self

func _on_mouse_exited():
	print ("gear area exited, with gear of", gear_name)
	if InputManager.hovered_gear == self:
		InputManager.hovered_gear = null
