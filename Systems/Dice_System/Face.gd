extends Resource
class_name Face

var pips : int
var face_type : Enums.FaceType = Enums.FaceType.NONE
var upgrade : Dictionary

func show_pips():
	print (pips)
	print ("face self is ", self)
