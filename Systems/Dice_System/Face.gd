extends Resource
class_name Face

var skill_name : String
var skill_actions : Array
var pips : int
var face_type : Enums.FaceType = Enums.FaceType.NONE
var skill_target : Enums.SkillTarget

func show_pips():
	print (pips)
	print ("face self is ", self)
