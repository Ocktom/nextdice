extends Node2D
class_name Cell

@onready var value_label : Label = $Value_Label
@onready var cell_color : ColorRect = $Cell_Color
@onready var cell_area: Area2D = $Cell_Area

var occupant : Card = null
var cell_vector: Vector2i   # Position in grid coordinates (x,y)

func _ready() -> void:
	cell_area.connect("mouse_entered", _on_mouse_entered)
	cell_area.connect("mouse_exited", _on_mouse_exited)


func spawn_card(card : Card):
	
	var card_path : PackedScene = preload("res://Systems/Card_System/Card.tscn")
	var new_card = card_path.instantiate()
	
	#if name_pick == "":
		#name_pick = Cards.card_data_dictionary.keys().pick_random()
	
	#print ("name pick for new card is", name_pick)
	#new_card.card_name = name_pick
	Global.world.card_layer.add_child(new_card)
	await fill_with_card(new_card)

func clear_cell():
	
	occupant = null

func fill_with_card(card : Card):
	occupant = card
	card.current_cell = self
	card.global_position = global_position

func insert_dice(dice : Dice):
	
	print ("cell received dice")
	var adjacent_cells = Global.grid.get_adjacent_cells(self)
	for cell in adjacent_cells:
		if not cell.is_empty():
			cell.occupant.apply_value(dice.dice_color,dice.current_face.pips)

func _on_mouse_entered():
	
	print("cell hovered, occupant is ", occupant)
	InputManager.hovered_cell = self

func _on_mouse_exited():
	if InputManager.hovered_cell == self:
		InputManager.hovered_cell = null

func is_empty() -> bool:
	
	var is_empty : bool
	if occupant == null: is_empty = true
	else: is_empty = false
	
	return is_empty
