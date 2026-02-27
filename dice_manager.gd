extends Node

var skill_data_dictionary : Dictionary
var skill_data
var skill_names : Array = []

func _ready() -> void:
	
	var skill_data_script = load("res://Systems/Skill_System/skill_data_dictionary.gd").new()
	skill_data_dictionary = skill_data_script.data
	skill_names = skill_data_dictionary.keys()
	
func setup_dice():
	for x in Global.player_dice:
		var ind = Global.player_dice.find(x)
		var dice_set = GearManager.skill_sets[ind]
		
		for i in range(6):
			var skill_name : String
			if i < dice_set.size():
				skill_name = dice_set[i]
			else:
				skill_name = "nothing"
			
			var face = x.faces[i]
			await insert_skill_to_face(skill_name, face)

func insert_skill_to_face(skill_name : String, face: Face):
	var skill = load("res://Systems/Skill_System/Skill_Scripts/skill_" + skill_name + ".gd").new()
	
	print("loading skill_name of ", skill_name, " skill is ", skill)
	
	var skill_data = skill_data_dictionary.get(skill_name, {})
	
	skill.skill_name = skill_name
	skill.face = face
	skill.skill_target = Enums.SkillTarget.get(skill_data.get("skill_target", "NONE"))
	skill.range = skill_data.get("skill_range", 1)
	
	face.skill = skill
	face.update()

func highlight_useable_cells(dragging_dice: Dice):
	
	#While we COULD just check each cell for is_useable(draggign_dice), we may want this to be its own fucntion
	#so ath you can highlight units that will be damaged, say for bladewalk or whatever
	
	for x in Global.grid.all_cells:
		
		x.highlight = false
			
		if x.is_empty():
		
			if InputManager.dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.STRAIGHT_EMPTY_CELL \
			or InputManager.dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.STRAIGHT_ANY_CELL:
				if Global.grid.has_straight_path(Global.hero_unit.current_cell,x):
					x.highlight = true
					continue
			
			if InputManager.dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.LOS_EMPTY_CELL \
			or InputManager.dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.LOS_ANY_CELL:
				
				if Global.grid.has_clear_path(Global.hero_unit.current_cell,x):
					x.highlight = true
					continue
			
			if InputManager.dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.ANY_CELL \
			or InputManager.dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.EMPTY_CELL:
					x.highlight = true
					continue
					
				
		elif x.occupant is Enemy:
			
			if InputManager.dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.ENEMY_UNIT \
			or InputManager.dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.LOS_ENEMY_UNIT \
			or InputManager.dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.ANY_UNIT \
			or InputManager.dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.LOS_ANY_UNIT \
			or InputManager.dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.ANY_CELL \
			or InputManager.dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.LOS_ANY_CELL:
			
				var path_cells = Global.grid.get_cells_in_path(Global.hero_unit.current_cell,x)
				for y in path_cells:
					y.highlight = true
			
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
			
			if dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.LOS_ANY_UNIT \
			or dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.LOS_ENEMY_UNIT\
			or dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.LOS_ANY_CELL:
				
				if Global.grid.has_clear_path(Global.hero_unit.current_cell,hovered_cell):
					return true
				else:
					return false
					Global.float_text("NEEDS CLEAR PATH",hovered_cell.global_position,Color.INDIAN_RED)
			
			if dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.STRAIGHT_ANY_UNIT \
			or dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.STRAIGHT_ENEMY_UNIT\
			or dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.STRAIGHT_ANY_CELL:
				if Global.grid.has_straight_path(Global.hero_unit.current_cell,hovered_cell):
					return true
				else:
					return false
					Global.float_text("NEEDS STRAIGHT PATH",hovered_cell.global_position,Color.INDIAN_RED)
			
			if dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.ENEMY_UNIT \
			or dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.ANY_UNIT \
			or dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.ANY_CELL:
				return true
			else:
				return false
			
	elif hovered_cell.is_empty():
		
			if dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.LOS_EMPTY_CELL \
			or dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.LOS_ANY_CELL:
				
				if Global.grid.has_clear_path(Global.hero_unit.current_cell,hovered_cell):
					return true
				else:
					return false
					Global.float_text("NEEDS CLEAR PATH",hovered_cell.global_position,Color.INDIAN_RED)
			
			if dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.STRAIGHT_EMPTY_CELL\
			or dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.STRAIGHT_ANY_CELL:
				if Global.grid.has_straight_path(Global.hero_unit.current_cell,hovered_cell):
					return true
				else:
					return false
					Global.float_text("NEEDS STRAIGHT PATH",hovered_cell.global_position,Color.INDIAN_RED)
			
			if dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.EMPTY_CELL \
			or dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.ANY_CELL:
				return true
			
			else:
				return false
	
	Global.float_text("no useable checks passed",hovered_cell.global_position,Color.INDIAN_RED)
	return false
