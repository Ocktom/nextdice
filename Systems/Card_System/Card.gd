extends Node2D
class_name Card

var current_cell: Cell
var card_value : int = 10
var card_name : String = "Card"

var highlight := false
var slot_value : int

var hp := 12

var sprite_path : String

var border_color : Color = Color.WHITE
var normal_color : Color = Color.BLACK
var normal_border_color : Color = Color.WHITE
var warm_color : Color = Color.DARK_SALMON
var hot_color : Color = Color.ORANGE_RED
var card_color := normal_color

var damaged := false
var watched := false : 

	set(new_value):
		if watched != new_value:
			watched = new_value
			update_visuals()

var damage_amount := 0

@onready var card_area : Area2D = $Card_Area

@onready var card_name_label : Label = $Card_Name_Label
@onready var hp_label : Label = $VBoxContainer/HP_Label
@onready var slot_label: Label = $Slot_Label

@onready var card_rect: ColorRect = $card_rect
@onready var border_rect: ColorRect = $border_rect

func _ready():
	
	hp = randi_range(1,3)
	
	slot_value = randi_range(1,7)
	
	Global.all_cards.append(self)
	card_value = randi_range(5,15)
		
	card_area.connect("mouse_entered", _on_mouse_entered)
	card_area.connect("mouse_exited", _on_mouse_exited)

	await update_visuals()

func destroy(overkill := false):
	
	queue_free()

func discard():
	
	print ("discarding!")
	await Global.animate(self,Enums.Anim.SQUISH)
	await Global.timer(.07)
	visible = false
	await Global.float_text("DISCARDED",position,Color.ROSY_BROWN)
	Global.all_cards.erase(self)
	await current_cell.clear_cell()
	
	queue_free()
	
func activate_slot(color : Enums.DiceColor, amount : int):
	
	var color_label : Label
	
	color_label = hp_label
	hp = max(0,hp-amount)
	
	Global.animate(color_label,Enums.Anim.FLASH,Color.WHITE)
	Global.animate(color_label,Enums.Anim.POP)
	
	print ("card value set for ", amount)
	update_visuals()

func apply_destroy_effects():
	
	pass

func damage():
	
	print ("was damaged")
	Global.animate(self,Enums.Anim.SHAKE)
	await Global.animate(self,Enums.Anim.FLASH,Color.RED)
	await Global.float_text("Damage",global_position,Color.RED)
	await Global.timer(.1)
	
	hp = max(0,hp-1)
	
	if hp < 1:
		
		destroy()
	
	update_visuals()
	
func assign_to_cell(cell: Cell) -> void:
	
	if current_cell != null:
		current_cell.occupant = null

	current_cell = cell
	current_cell.occupant = self
	position = current_cell.global_position

func check_spawn_effects():
	
	pass
	
func update_visuals():
	hp_label.text = str(hp)
	slot_label.text = str(slot_value)
	
func get_grid_position() -> Vector2i:
	
	if current_cell != null:
		return current_cell.grid_position
	return Vector2i(-1, -1)
		
func _on_mouse_entered():
	InputManager.hovered_card = self

func _on_mouse_exited():
	if InputManager.hovered_card == self:
		InputManager.hovered_card = null
	
func toggle_highlight():
	if highlight:
		highlight = false
		border_rect.visible = false
	else:
		highlight = true
		border_rect.visible = true
