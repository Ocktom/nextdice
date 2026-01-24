# FloatingText.gd
extends Node2D

@onready var label = $Label

var float_speed := 120.0  # pixels per second
var lifetime := 0.8      # seconds
var fade_time := 0.3     # seconds at end of lifetime
var elapsed := 0.0

func _ready():
	set_process(true)

func _process(delta):
	elapsed += delta
	position.y -= float_speed * delta

	if elapsed > lifetime:
		queue_free()
	elif elapsed > lifetime - fade_time:
		var alpha = 1.0 - ((elapsed - (lifetime - fade_time)) / fade_time)
		label.modulate.a = alpha

func show_text(message: String, color: Color = Color.WHITE):
	label.text = message
	label.modulate = color
