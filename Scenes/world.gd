extends Node2D

@onready var card_layer : Node2D = $Card_Layer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Global.world = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
