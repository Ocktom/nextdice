extends Resource
class_name Face

var skill_name : String
var skill_actions : Array

var skill : Skill
var skill_range := 0

var skill_target : Enums.SkillTarget

func show_pips():
	print ("face self is ", self)

func update():
	skill_range = skill.range

func clear_skill():
	skill_name = ""
	skill_actions = []
	skill = null
	skill_target = Enums.SkillTarget.ANY_CELL
