extends Node2D
class_name Unit

var current_cell: Cell
var unit_name : String = "Unit"
@onready var status_sprites: HBoxContainer = $Status_Sprites

var status_icons : Array[Node]

var highlight := false
var sprite_path : String
var range_type : Enums.RangeType

var unit_passives : Dictionary

var border_color : Color = Color.WHITE
var normal_color : Color = Color.BLACK

var damaged := false

var status_effects : Dictionary = {}

@onready var unit_name_label : Label = $Unit_Name_Label
@onready var effects_sprite: AnimatedSprite2D = $Effects_Sprite

func _ready():
	
	print ("unit passives for ", unit_name, " is ", unit_passives)
	Global.all_units.append(self)
	status_icons = status_sprites.get_children()
	await update()

func destroy(overkill := false):
	
	pass

func remove():
	
	print ("disuniting!")
	await Global.animate(self,Enums.Anim.SQUISH)
	await Global.timer(.07)
	visible = false
	await Global.float_text("DISCARDED",position,Color.ROSY_BROWN)
	Global.all_units.erase(self)
	await current_cell.clear_cell()
	
	queue_free()

func apply_destroy_effects():
	
	pass

func assign_to_cell(cell: Cell) -> void:
	
	if current_cell != null:
		current_cell.occupant = null

	current_cell = cell
	current_cell.occupant = self
	position = current_cell.global_position

func update():
	
	unit_name_label.text = str(unit_name)

func get_grid_position() -> Vector2i:
	
	if current_cell != null:
		return current_cell.grid_position
	return Vector2i(-1, -1)
		
func _on_mouse_entered():
	
	InputManager.hovered_unit = self
	if not InputManager.dragging_dice == null:
		toggle_highlight()

func _on_mouse_exited():
	if InputManager.hovered_unit == self:
		InputManager.hovered_unit = null
	
	if highlight:
		toggle_highlight()
	
func toggle_highlight():
	if highlight:
		highlight = false
	else:
		highlight = true

func is_adjacent(cell: Cell)-> bool:
	var adjacent_cells = Global.grid.get_adjacent_cells(cell)
	if adjacent_cells.has(cell):
		return true
	else:
		return false
