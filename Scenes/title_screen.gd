extends Control
@onready var start_button: Button = $Start_Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.connect("pressed",_on_start_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_pressed():
	await Global.main.start_game()
	queue_free()
