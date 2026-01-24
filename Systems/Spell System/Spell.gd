extends Node2D
class_name Spell

var spell_name : String = "Spell"

var starting_cost := 8
var current_cost := 8

var highlight := false

var current_slot : Spell_Slot
var sprite_path : String

var border_color : Color = Color.WHITE
var normal_color : Color = Color.BLACK

var damaged := false

@onready var background_rect: ColorRect = $Background_Rect
@onready var unit_area : Area2D = $Unit_Area

@onready var unit_name_label : Label = $Unit_Name_Label
@onready var hp_label : Label = $VBoxContainer/HP_Label
@onready var cost_label: Label = $Cost_Label

@onready var unit_rect: ColorRect = $unit_rect
@onready var border_rect: ColorRect = $border_rect

func _ready():

	await update_visuals()

func pay_cost(amount : int):

	Global.animate(background_rect,Enums.Anim.FLASH,Color.WHITE)
	Global.animate(self,Enums.Anim.POP)
	
	current_cost = max(0,current_cost-amount)
	
	print ("unit value set for ", amount)
	update_visuals()

func update_visuals():
	unit_name_label.text = str(spell_name)
	cost_label.text = str(current_cost)
		
func toggle_highlight():
	if highlight:
		highlight = false
		border_rect.visible = false
	else:
		highlight = true
		border_rect.visible = true
