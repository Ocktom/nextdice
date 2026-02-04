extends Node

signal enemy_damaged
signal hero_damaged
signal unit_damaged

signal enemy_attacked
signal hero_attacked
signal unit_attacked

signal turn_start

signal enemy_death

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	print ("signal bus ready")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
