extends Control
class_name StatusIcon

var status_name : String

@onready var value_label: Label = $value_label
@onready var icon_texture: TextureRect = $icon_texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
