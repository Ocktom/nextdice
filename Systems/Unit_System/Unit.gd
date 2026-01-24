extends Node2D
class_name Unit

var current_cell: Cell
var unit_name : String = "Unit"

var highlight := false

var hp := 12

var sprite_path : String

var border_color : Color = Color.WHITE
var normal_color : Color = Color.BLACK

var damaged := false

var damage_amount := 0

@onready var unit_area : Area2D = $Unit_Area

@onready var unit_name_label : Label = $Unit_Name_Label
@onready var hp_label : Label = $VBoxContainer/HP_Label

@onready var background_rect: ColorRect = $Background_Rect
@onready var border_rect: ColorRect = $border_rect

func _ready():
	
	hp = randi_range(2,7)
	
	Global.all_units.append(self)

	await update_visuals()

func destroy(overkill := false):
	
	queue_free()

func remove():
	
	print ("disuniting!")
	await Global.animate(self,Enums.Anim.SQUISH)
	await Global.timer(.07)
	visible = false
	await Global.float_text("DISCARDED",position,Color.ROSY_BROWN)
	Global.all_units.erase(self)
	await current_cell.clear_cell()
	
	queue_free()
	
func activate_slot(color : Enums.DiceColor, amount : int):
	
	var color_label : Label
	
	color_label = hp_label
	hp = max(0,hp-amount)
	
	Global.animate(color_label,Enums.Anim.FLASH,Color.WHITE)
	Global.animate(color_label,Enums.Anim.POP)
	
	print ("unit value set for ", amount)
	update_visuals()

func apply_destroy_effects():
	
	pass

func damage(amount : int):
	
	print ("was damaged")
	Global.animate(self,Enums.Anim.SHAKE)
	await Global.animate(self,Enums.Anim.FLASH,Color.RED)
	await Global.float_text("Damage",global_position,Color.RED)
	await Global.timer(.1)
	
	hp = max(0,hp-amount)
	
	if hp < 1:
		
		destroy()
	
	update_visuals()
	
func assign_to_cell(cell: Cell) -> void:
	
	if current_cell != null:
		current_cell.occupant = null

	current_cell = cell
	current_cell.occupant = self
	position = current_cell.global_position

func update_visuals():
	unit_name_label.text = str(unit_name)
	hp_label.text = str(hp)
	
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
		border_rect.visible = false
	else:
		highlight = true
		border_rect.visible = true
