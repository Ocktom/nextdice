extends Node

var skill_data_dictionary : Dictionary
var skill_data
var skill_names : Array = []

var dice_1_set : Array[String] = ["travel_shield","travel_shield","poison_strike","poison_strike","poison_strike","travel_blade"]
var dice_2_set : Array[String] = ["frost_walk","fire_walk","fire_walk","hookshot","frost_walk","blade_walk"]
var dice_3_set : Array[String] = ["poison_hunter","poison_hunter","enhance_poison","enhance_poison","enhance_poison","fire_hunter"]

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
			var skill = load(str("res://Systems/Skill_System/Skill_Scripts/skill_",(dice_set[face_ind]),".gd")).new()
			y.skill = skill
			y.skill_name = (dice_set[face_ind])
			y.skill_target = Enums.SkillTarget[SkillManager.skill_data_dictionary[y.skill_name]["skill_target"]]
			y.skill_range = skill.range
			y.skill.face = y
		
func insert_skill_to_face(skill_name : String, face: Face):
	
	var skill = load(str("res://Systems/Skill_System/Skill_Scripts/skill_",skill_name,".gd")).new()
	face.skill = skill
	face.skill_name = skill_name
	
func is_useable(dragging_dice: Dice, hovered_cell : Cell, float_text : bool = true) -> bool:
							
	var distance = Global.grid.get_distance(Global.hero_unit.current_cell,hovered_cell)
	var range = dragging_dice.current_face.skill_range
	
	print ("running is_useable check, range is ", range)
	
	if distance > range:
		print ("out of range")
		if float_text: Global.float_text("OUT OF RANGE",hovered_cell.global_position,Color.INDIAN_RED)
		return false
	
	if not hovered_cell.occupant == null:
		
		if hovered_cell.occupant is Enemy:
			
			if dragging_dice.current_face.skill_target == Enums.SkillTarget.LOS_UNIT:
				if not Global.grid.has_clear_path(Global.hero_unit.current_cell,hovered_cell):
					
					if float_text: Global.float_text("NEEDS LOS",hovered_cell.global_position,Color.INDIAN_RED)
					return false
			
			if not dragging_dice.current_face.skill_target == Enums.SkillTarget.ENEMY_UNIT \
			and not dragging_dice.current_face.skill_target == Enums.SkillTarget.ANY_UNIT \
			and not dragging_dice.current_face.skill_target == Enums.SkillTarget.LOS_UNIT \
			and not dragging_dice.current_face.skill_target == Enums.SkillTarget.ANY_CELL:
				
					if float_text: Global.float_text("INVALID TARGET",hovered_cell.global_position,Color.INDIAN_RED)
					return false
			
			if hovered_cell.occupant.status_effects.keys().has("invisible"):
				if float_text: Global.float_text("Invisible",hovered_cell.global_position,Color.WHITE)
				return false
				
			return true
			
	elif hovered_cell.is_empty():
		
		if not dragging_dice.current_face.skill_target == Enums.SkillTarget.EMPTY_CELL \
		and not dragging_dice.current_face.skill_target == Enums.SkillTarget.ANY_CELL:
			
			print ("dragging_dice.current_face.skill_target is ", dragging_dice.current_face.skill_target)
			if float_text: Global.float_text("INVALID TARGET",hovered_cell.global_position,Color.INDIAN_RED)
			return false
		
		else:
			return true
	
	if float_text: Global.float_text("no useable checks passed",hovered_cell.global_position,Color.INDIAN_RED)
	return false
		
func get_skills_of_type(type_string):
	pass
