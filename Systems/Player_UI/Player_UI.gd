extends Control

@onready var hp_label: Label = $VBoxContainer/HP_Label
@onready var rolls_label: Label = $VBoxContainer/Rolls_Label
@onready var gold_label: Label = $VBoxContainer/Gold_Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update():
	hp_label.text = str("HP: ", PlayerStats.player_hp)
	rolls_label.text = str("Rolls: ", PlayerStats.rolls)
	gold_label.text = str("Gold: ", PlayerStats.gold)
