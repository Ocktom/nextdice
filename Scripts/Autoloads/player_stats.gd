extends Node

var spaces_moved_this_turn := 0

var player_str := 3
var player_dex := 3
var player_int := 3

var move_points := 2

var mana := 0
var max_mana := 2
var max_hp := 5
var player_hp := 8

var starting_chests:= 2

var shield_bonus := 0
var heal_bonus := 0
var poison_bonus := 0
var fire_bonus := 0

var crit_chance := 0
var crit_damage := 0

var status_effects : Dictionary = {}

var max_rolls := 3
var rolls := 3

var relics : Array[Item]
var gold := 0

var fire_damage := {"base" : 1, " game_bonus" : 0, "round_bonus" : 0, "turn_bonus" : 0}
var poison_damage := {"base" : 1, " game_bonus" : 0, "round_bonus" : 0, "turn_bonus" : 0}
var attack_damage := {"base" : 1, " game_bonus" : 0, "round_bonus" : 0, "turn_bonus" : 0}
var magic_damage := {"base" : 1, " game_bonus" : 0, "round_bonus" : 0, "turn_bonus" : 0}
var physical_damage := {"base" : 1, " game_bonus" : 0, "round_bonus" : 0, "turn_bonus" : 0}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
