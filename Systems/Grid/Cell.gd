extends Node2D
class_name Cell

@onready var value_label : Label = $Value_Label
@onready var cell_color : ColorRect = $Cell_Color
@onready var cell_area: Area2D = $Cell_Area

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
	occupant = unit
	unit.current_cell = self
	unit.global_position = global_position

func move_hero(dice : Dice):
	
	Global.hero_unit.current_cell.clear_cell()
	fill_with_unit(Global.hero_unit)

func _on_mouse_entered():
	
	print("cell hovered, occupant is ", occupant)
	InputManager.hovered_cell = self

	if not InputManager.dragging_dice == null:
		if not occupant == null:
			if occupant is Enemy:
				if not occupant.highlight:
					occupant.toggle_highlight()

func _on_mouse_exited():
	
	if InputManager.hovered_cell == self:
		InputManager.hovered_cell = null
	
	if not occupant == null:
		if occupant.highlight:
			occupant.toggle_highlight()
				
func is_empty() -> bool:
	
	var is_empty : bool
	if occupant == null: is_empty = true
	else: is_empty = false
	
	return is_empty
