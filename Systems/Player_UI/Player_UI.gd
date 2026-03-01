extends Control

@onready var hp_label: Label = $VBoxContainer/HP_Label
@onready var rolls_label: Label = $VBoxContainer/Rolls_Label
@onready var gold_label: Label = $VBoxContainer/Gold_Label
@onready var move_label: Label = $VBoxContainer/Move_Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update():
	hp_label.text = str("HP: ", Global.player_stats.player_hp)
	rolls_label.text = str("Rolls: ", Global.player_stats.rolls)
	gold_label.text = str("Gold: ", Global.player_stats.gold)
	move_label.text = str("Move:", Global.player_stats.move_points)
