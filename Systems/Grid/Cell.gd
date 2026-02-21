extends Node2D
class_name Cell

@onready var cell_area: Area2D = $Cell_Area
@onready var cell_highlight: ColorRect = $Cell_Highlight
@onready var cell_effect_ov: TextureRect = $Cell_Effect_OV
@onready var cell_animation: AnimatedSprite2D = $Cell_Animation


var cell_effect : Enums.CellEffect

var highlight : bool :
	set(new_value):
		if highlight != new_value:
			highlight = new_value
		if highlight:
			cell_highlight.visible = true
		else:
			cell_highlight.visible = false

var poison := false : 
	set(new_value):
		poison = new_value
			
var occupant : Unit = null
var cell_vector: Vector2i   # Position in grid coordinates (x,y)

func _ready() -> void:
	cell_area.connect("mouse_entered", _on_mouse_entered)
	cell_area.connect("mouse_exited", _on_mouse_exited)
	
func spawn_unit(new_unit : Unit):
	var spawn_layer : Node2D
	spawn_layer = Global.world.hero_layer if new_unit == Global.hero_unit else Global.world.unit_layer
		
	spawn_layer.add_child(new_unit)
	await fill_with_unit(new_unit)

func clear_cell():
	
	occupant = null
	Global.unhighlight_cells()

func fill_with_unit(unit : Unit):
	print ("fill_with_unit called", unit.unit_name)
	occupant = unit
	unit.current_cell = self
	unit.global_position = global_position
	
	apply_cell_effects_to_unit()
	unit.update()

func apply_cell_effects_to_unit():
	
	if occupant == null:
		return
	
	if cell_effect != Enums.CellEffect.NONE:
		
		match cell_effect:
		
			Enums.CellEffect.WEB:
				
				if occupant != null:
					ActionManager.create_action("status_effect",{"status_name" : "ROOT", "amount" : 1 },self,self)
					cell_effect = Enums.CellEffect.NONE
					
			Enums.CellEffect.FIRE:
				
				ActionManager.create_action("status_effect",{"status_name" : "BURN", "amount" : 1 },self,self)
			
			Enums.CellEffect.SNOW:
				
				ActionManager.create_action("status_effect",{"status_name" : "FROST", "amount" : 2 },self,self)
		
		occupant.update()
	
func move_hero(dice : Dice):
	
	Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNMisc_MOVEMENT-Retro Jump_HY_PC-001.wav")
	Global.hero_unit.current_cell.clear_cell()
	fill_with_unit(Global.hero_unit)

func _on_mouse_entered():

	if Global.game_state == Enums.GameState.PLAYER_TURN:
				
		print("cell hovered, occupant is ", occupant)
		InputManager.hovered_cell = self
		
		return
		
		Global.unhighlight_cells()
		
		if InputManager.dragging_dice != null:
			
			if not SkillManager.is_useable(InputManager.dragging_dice,self,false):
				print ("not highlighting, useable check not passed")
				return
			
			if is_empty():
			
				if InputManager.dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.ANY_CELL \
				or InputManager.dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.EMPTY_CELL \
				or InputManager.dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.LOS_ANY_CELL \
				or InputManager.dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.LOS_EMPTY_CELL :
				
					var path_cells = Global.grid.get_cells_in_path(Global.hero_unit.current_cell,self)
					for x in path_cells:
						x.highlight = true
						
					
			elif occupant is Enemy:
				
				if InputManager.dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.ENEMY_UNIT \
				or InputManager.dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.LOS_ENEMY_UNIT \
				or InputManager.dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.ANY_UNIT \
				or InputManager.dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.LOS_ANY_UNIT \
				or InputManager.dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.ANY_CELL \
				or InputManager.dragging_dice.current_face.skill.skill_target == Enums.SkillTarget.LOS_ANY_CELL:
				
					var path_cells = Global.grid.get_cells_in_path(Global.hero_unit.current_cell,self)
					for x in path_cells:
						highlight = true
				
		elif occupant is Enemy:
			for x in occupant.get_attack_cells():
				x.highlight = true
			
func _on_mouse_exited():
	if Global.game_state == Enums.GameState.PLAYER_TURN:
		
		if InputManager.hovered_cell == self:
			InputManager.hovered_cell = null
		
		#if InputManager.hovered_cell == null:
			#for x in Global.grid.all_cells:
				#x.highlight = false
			
func is_empty() -> bool:
	
	var is_empty : bool
	if occupant == null: is_empty = true
	else: is_empty = false
	
	return is_empty

func is_adjacent(cell : Cell, include_diagonal := false) -> bool:
	var adjacents = Global.grid.get_adjacent_cells(self, include_diagonal)
	if adjacents.has(cell):
		return true
	else:
		return false

func update():
	
	cell_effect_ov.visible = true
	
	match cell_effect:
		Enums.CellEffect.NONE: cell_effect_ov.visible = false
		Enums.CellEffect.WEB: cell_effect_ov.texture = load("res://Art/Cell_Effect_Sprites/web.png")
		Enums.CellEffect.FIRE: cell_effect_ov.texture = load("res://Art/Cell_Effect_Sprites/fire.png")
		Enums.CellEffect.GRASS: cell_effect_ov.texture = load("res://Art/Cell_Effect_Sprites/grass.png")
		Enums.CellEffect.SNOW: cell_effect_ov.texture = load("res://Art/Cell_Effect_Sprites/snow.png")
	
	if cell_effect == Enums.CellEffect.FIRE:
		cell_animation.visible = true
		
		for x in Global.grid.get_adjacent_cells(self):
			if x.cell_effect == Enums.CellEffect.GRASS:
				ActionManager.request_action("cell_effect",{"cell_effect" : "FIRE"},self,x)
	else:
		cell_animation.visible = false
	
