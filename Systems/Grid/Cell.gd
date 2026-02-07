extends Node2D
class_name Cell

@onready var cell_color : ColorRect = $Cell_Color
@onready var cell_area: Area2D = $Cell_Area
@onready var cell_highlight: ColorRect = $Cell_Highlight
@onready var cell_effect_ov: TextureRect = $Cell_Effect_OV

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
		if poison:
			cell_color.color = Color.SEA_GREEN
			
var occupant : Unit = null
var cell_vector: Vector2i   # Position in grid coordinates (x,y)

func _ready() -> void:
	cell_area.connect("mouse_entered", _on_mouse_entered)
	cell_area.connect("mouse_exited", _on_mouse_exited)
	
func spawn_unit(new_unit : Unit):

	Global.world.unit_layer.add_child(new_unit)
	await fill_with_unit(new_unit)

func clear_cell():
	
	occupant = null
	Global.unhighlight_cells()

func fill_with_unit(unit : Unit):
	print ("fill_with_unit called")
	occupant = unit
	unit.current_cell = self
	unit.global_position = global_position
	
	if cell_effect == Enums.CellEffect.WEB:
		ActionManager.create_action("status_effect",{"color" : "WHITE","status_name" : "ROOT", "amount" : 1 },self,occupant)
		cell_effect = Enums.CellEffect.NONE
		update()
	
	unit.update()
	
func move_hero(dice : Dice):
	
	Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNMisc_MOVEMENT-Retro Jump_HY_PC-001.wav")
	Global.hero_unit.current_cell.clear_cell()
	fill_with_unit(Global.hero_unit)

func _on_mouse_entered():

	if Global.game_state == Enums.GameState.PLAYER_TURN:
				
		print("cell hovered, occupant is ", occupant)
		InputManager.hovered_cell = self
		
		Global.unhighlight_cells()
		
		if InputManager.dragging_dice != null:
			
			if is_empty():
			
				if InputManager.dragging_dice.current_face.skill_target == Enums.SkillTarget.ANY_CELL \
				or InputManager.dragging_dice.current_face.skill_target == Enums.SkillTarget.EMPTY_CELL:
				
					var path_cells = Global.get_path_cells(Global.hero_unit.current_cell,self,PlayerStats.move_points)
					for x in path_cells:
						x.highlight = true
			elif occupant is Enemy:
				if is_adjacent(Global.hero_unit.current_cell):
					highlight = true
				
		elif occupant is Enemy:
			for x in occupant.get_attack_cells():
				x.highlight = true
			
func _on_mouse_exited():
	if Global.game_state == Enums.GameState.PLAYER_TURN:
		
		if InputManager.hovered_cell == self:
			InputManager.hovered_cell = null
		
		if InputManager.hovered_cell == null:
			for x in Global.grid.all_cells:
				x.highlight = false
			
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
		Enums.CellEffect.WEB: cell_effect_ov.texture = load("res://Art/spiderweb.png")
		Enums.CellEffect.FIRE: cell_effect_ov.texture = load("res://Art/fire_cell.png")
		
