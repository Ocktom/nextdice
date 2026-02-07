extends Node

var player_str := 2
var player_dex := 2
var player_int := 2

var move_points := 2

var mana := 0
var max_mana := 2
var max_hp := 5
var player_hp := 5

var status_effects : Dictionary = {}

var max_rolls := 3
var rolls := 3

var relics : Array[Item]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
