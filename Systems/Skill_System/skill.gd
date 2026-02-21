extends Node
class_name Skill

var face : Face
var skill_target : Enums.SkillTarget
var range := 1
var skill_name: String

func execute(action_source: Cell, action_target_cell: Cell, context_dict : Dictionary = {}):
	print ("SKILL USED")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
