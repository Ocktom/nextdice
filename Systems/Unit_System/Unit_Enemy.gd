extends Unit
class_name Enemy

@onready var hp_label: Label = $Right_Stats/HBoxContainer/HP_Label
@onready var shield_label: Label = $Right_Stats/HBoxContainer/SHIELD_Label
@onready var atk_label: Label = $Right_Stats/ATK_Label
@onready var sprite_ov: Sprite2D = $Sprite_OV

@onready var right_stats: VBoxContainer = $Right_Stats


var hp : int
var max_hp : int
var poison : int
var burn : int
var stun : bool
var forcefield : bool
var shield : int
var invisible : int

var atk := 1
var atk_range := 1

var frozen := false

var move_diag := false

var attack_diag : bool
var attack_cardinal : bool

var turn_bonus := 0
var round_bonus := 0

var passive_1_name : String
var passive_1 : Passive
var passive_1_trigger : Enums.Trigger

var passive_2_name : String
var passive_2 : Passive

var enemy_actions: Dictionary

var projectile := false
var movement := 2

var wait_time := .2
var step_time := .1

var acted_this_turn := false

func set_passives():
	
	if not passive_1_name == "":
		passive_1 = Passive.new()
		var script_path = str("res://Systems/Passive_System/Passive_Scripts/passive_",passive_1_name,".gd")
		print ("setting passive script_path for ", script_path)
		passive_1.set_script(load(script_path))
		passive_1.passive_name = passive_1_name
		print ("passive_1 is ", passive_1, " with name of ", passive_1.passive_name)
		passive_1.source = self
		passive_1.set_trigger()
	if not passive_2_name == "":
		passive_2 = Passive.new()
		var script_path = str("res://Systems/Passive_System/Passive_Scripts/",passive_2_name,".gd")
		passive_2.set_script(load(script_path))
		passive_1.source = self
		passive_2.set_trigger()

func update():
	
	hp_label.text = str(hp)
	atk_label.text = str(atk)
	
	await Global.status_manager.update_status_effects(self)
