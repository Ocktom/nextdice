extends Control
class_name Replace_SKill

var stat_name : String
var stat_amount : int

var old_skill : String
var new_skill : String
var face_picked : Face

var reward_screen: Control

@onready var old_sprite: TextureRect = $Skill_Replace/HBoxContainer/old_sprite
@onready var new_sprite: TextureRect = $Skill_Replace/HBoxContainer2/new_sprite
@onready var item_button: Button = $Item_Button

func _ready() -> void:
	item_button.connect("pressed",_on_button_pressed)

func pick_random_skills():
	
	var all_faces: Array
	
	print ("player dice is", Global.player_dice)
	
	for x in Global.player_dice:
		print ("checking ", x, " with faces of ", x.faces)
		for y in x.faces:
			all_faces.append(y)
			print ("checking face of ", y)
			print ("skill name is ", y.skill.skill_name)
	
	face_picked = all_faces.pick_random()
	old_skill = face_picked.skill.skill_name
	
	new_skill = SkillManager.skill_data_dictionary.keys().pick_random()
	print ("new_skill_name chosen is ", new_skill)
	new_sprite.texture = load(str("res://Art/Skill_Sprites/",new_skill,".png"))
	old_sprite.texture = load(str("res://Art/Skill_Sprites/",old_skill,".png"))
	
	print ("old skill chosen ", old_skill, " new skill chosen ", new_skill)
	
func choose():
	await SkillManager.insert_skill_to_face(new_skill,face_picked)
	Global.game_state = Enums.GameState.PLAYER_TURN
	reward_screen.queue_free()
	
func _on_button_pressed():
	await choose()
