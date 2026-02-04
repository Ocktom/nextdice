extends Node
class_name Upgrade

@onready var border_texture_rect: TextureRect = $Border_texture_rect
@onready var texture_rect: TextureRect = $TextureRect
@onready var background_rect: ColorRect = $Background_Rect
@onready var border_rect: ColorRect = $border_rect
@onready var item_name_label: Label = $Item_Name_Label
@onready var cost_label: Label = $Cost_Label

var upgrade_name : String
var description : String

var current_slot : Upgrade_Slot
var current_dice : Dice

var border_color : Color = Color.WHITE
var normal_color : Color = Color.BLACK


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
