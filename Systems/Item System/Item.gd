extends Node2D
class_name Item

var item_name : String
var item_cost : int
var description : String
var item_type : Enums.ItemType

var current_slot : Item_Slot

var border_color : Color = Color.WHITE
var normal_color : Color = Color.BLACK

var selected_target : Node2D
var damaged := false

@onready var background_rect: ColorRect = $Background_Rect

@onready var item_name_label : Label = $Item_Name_Label
@onready var cost_label: Label = $Cost_Label

@onready var border_rect: ColorRect = $border_rect

func _ready():
	print ("item node of, ", item_name, " is ready")
	update()
		
func update():
	
	item_name_label.text = item_name
	cost_label.text = str(item_cost)
