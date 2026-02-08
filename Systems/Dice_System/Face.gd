extends Resource
class_name Face

var skill_name : String
var skill_actions : Array

var skill : Skill
var skill_range := 0

var skill_target : Enums.SkillTarget

func show_pips():
	print ("face self is ", self)

func insert_skill(new_skill_name : String):
	print ("face received skill of ", skill_name)
	skill_name = new_skill_name
	skill = load(str("res://Systems/Skill_System/Skill_Scripts/skill_",skill_name,".gd")).new()
	skill_target = Enums.SkillTarget[SkillManager.skill_data_dictionary[skill_name]["skill_target"]]
	skill_range = skill.range
	
func update():
	skill_range = skill.range

func clear_skill():
	skill_name = ""
	skill_actions = []
	skill = null
	skill_target = Enums.SkillTarget.ANY_CELL
