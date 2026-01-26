extends Node2D
class_name Cell

@onready var cell_color : ColorRect = $Cell_Color
@onready var cell_area: Area2D = $Cell_Area

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

func fill_with_unit(unit : Unit):
	print ("fill_with_unit called")
	occupant = unit
	unit.current_cell = self
	unit.global_position = global_position

func move_hero(dice : Dice):
	
	Global.hero_unit.current_cell.clear_cell()
	fill_with_unit(Global.hero_unit)

func _on_mouse_entered():
	
	if Global.game_state == Enums.GameState.PLAYER_TURN:
		print("cell hovered, occupant is ", occupant)
		InputManager.hovered_cell = self

func _on_mouse_exited():
	if Global.game_state == Enums.GameState.PLAYER_TURN:
		
		if InputManager.hovered_cell == self:
			InputManager.hovered_cell = null
			
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
