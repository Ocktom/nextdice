extends Node

var skill_data_dictionary : Dictionary
var skill_data
var skill_names : Array = []


var dice_1_set : Array[String] = ["impaling_strike","cleaving_strike","guarded_strike","guarded_strike","strike","strike"]
var dice_2_set : Array[String] = ["move","persuing_strike","guarded_move","persuing_strike","persuing_strike","strike_through"]
var dice_3_set : Array[String] = ["mana","mana","mana","fireball","fireball","fireball"]

var all_dice_sets = [dice_1_set,dice_2_set,dice_3_set]

func _ready() -> void:
	
	var skill_data_script = load("res://Systems/Skill_System/skill_data_dictionary.gd").new()
	skill_data_dictionary = skill_data_script.data
	skill_names = skill_data_dictionary.keys()
	
func setup_dice():
	
	for x in Global.player_dice:
		var ind = Global.player_dice.find(x)
		var dice_set = all_dice_sets[ind]
		for y in x.faces:
			var face_ind = x.faces.find(y)
			y.skill_name = dice_set[face_ind]
			#var skill_actions = SkillManager.skill_data_dictionary[y.skill_name]["skill_actions"].split(", ")
			#y.skill_actions = skill_actions
			y.skill_target = Enums.SkillTarget[SkillManager.skill_data_dictionary[y.skill_name]["skill_target"]]
			print ("skill_target in setup is ", y.skill_target)

func is_useable(dragging_dice: Dice, hovered_cell : Cell) -> bool:
							
	if not hovered_cell.occupant == null:
		
		if hovered_cell.occupant is Enemy:
			
			if dragging_dice.current_face.skill_target == Enums.SkillTarget.LOS_UNIT:
				if not Global.grid.has_clear_path(Global.hero_unit.current_cell,hovered_cell):
					Global.float_text("NEEDS LOS",hovered_cell.global_position,Color.INDIAN_RED)
					return false
			
			if not dragging_dice.current_face.skill_target == Enums.SkillTarget.ENEMY_UNIT \
			and not dragging_dice.current_face.skill_target == Enums.SkillTarget.ANY_UNIT \
			and not dragging_dice.current_face.skill_target == Enums.SkillTarget.LOS_UNIT \
			and not dragging_dice.current_face.skill_target == Enums.SkillTarget.ANY_CELL:
				
					Global.float_text("INVALID TARGET",hovered_cell.global_position,Color.INDIAN_RED)
					return false
			
			if hovered_cell.occupant.status_effects.keys().has("invisible"):
				Global.float_text("Invisible",hovered_cell.global_position,Color.WHITE)
				return false
			
			if hovered_cell.is_adjacent(Global.hero_unit.current_cell, true):
				return true

			else:
				Global.float_text("Out of Range", Global.hero_unit.global_position)
				return false
			
	elif hovered_cell.is_empty():
		
		if not dragging_dice.current_face.skill_target == Enums.SkillTarget.EMPTY_CELL \
		and not dragging_dice.current_face.skill_target == Enums.SkillTarget.ANY_CELL:
			
			print ("dragging_dice.current_face.skill_target is ", dragging_dice.current_face.skill_target)
			Global.float_text("INVALID TARGET",hovered_cell.global_position,Color.INDIAN_RED)
			return false
		
		else:
			return true
			
	return false
		
		
