extends Node2D
class_name Card

var current_cell: Cell
var card_value : int = 10
var card_name : String = "Card"

var red_value := 12
var blue_value := 10
var green_value := 8

var heat : int = 0

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

@onready var red_value_label : Label = $VBoxContainer/Card_red_value
@onready var blue_value_label : Label = $VBoxContainer/Card_blue_value2
@onready var green_value_label : Label = $VBoxContainer/Card_blue_value3


@onready var card_color_rect : ColorRect = $card_rect
@onready var card_border_rect : ColorRect = $border_rect
@onready var card_name_label : Label = $Card_Name_Label


func _ready():
	
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
	
func apply_value(color : Enums.DiceColor, amount : int):
	
	var color_label : Label
	
	match color:
		Enums.DiceColor.RED:
			color_label = red_value_label
			red_value = max(0,red_value-amount)
		Enums.DiceColor.BLUE:
			color_label = blue_value_label
			blue_value = max(0,blue_value-amount)
		Enums.DiceColor.GREEN:
			color_label = green_value_label
			green_value = max(0,green_value-amount)
	
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
	visible = false
	await Global.float_text("BREAK!",global_position,Color.RED)
	await Global.timer(.1)
	
	Global.all_cards.erase(self)
	await current_cell.clear_cell()
	queue_free()

func assign_to_cell(cell: Cell) -> void:
	
	if current_cell != null:
		current_cell.occupant = null

	current_cell = cell
	current_cell.occupant = self
	position = current_cell.global_position

func check_spawn_effects():
	
	pass
	
func update_visuals():
	red_value_label.text = str(red_value)
	blue_value_label.text = str(blue_value)
	green_value_label.text = str(green_value)
	
func get_grid_position() -> Vector2i:
	
	if current_cell != null:
		return current_cell.grid_position
	return Vector2i(-1, -1)
		
func _on_mouse_entered():
	InputManager.hovered_card = self

func _on_mouse_exited():
	if InputManager.hovered_card == self:
		InputManager.hovered_card = null
