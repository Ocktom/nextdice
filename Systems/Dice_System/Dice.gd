extends Control
class_name Dice

@export var gear_slot_1: Gear_Slot
@export var gear_slot_2: Gear_Slot

var gear_slots : Array [Gear_Slot]

var faces : Array [Face]
var used_this_turn : bool :
	set(new_value):
		if used_this_turn != new_value: used_this_turn = new_value
		if used_this_turn:
			Global.world.update_sum()

var grey_out := false :
	set (new_value):
		if grey_out != new_value: grey_out = new_value
		if grey_out: grey_out_rect.visible = true
		else: grey_out_rect.visible = false
			
@onready var grey_out_rect: ColorRect = $GreyOut_Rect
@onready var dice_color_rect : ColorRect = $Face_Node/ColorRect
@onready var dice_area : Area2D = $Dice_Area
@onready var face_node : Control = $Face_Node
@onready var starting_pos : Vector2i = self.global_position

var current_face : Face

func _ready() -> void:
	
	gear_slots = [gear_slot_1,gear_slot_2]
	
	Global.player_dice.append(self)
	
	dice_area.connect("mouse_entered",_on_mouse_entered)
	dice_area.connect("mouse_exited",_on_mouse_exited)
	
	for x in range(1,7):
			
		var y = Face.new()
		y.pips = x
		
		faces.append(y)
	
	print ("dice faces are", faces)

func use():
	
	used_this_turn = true
	grey_out = true

func roll():
	
	#dice_color.color = Global.colors.pick_random()
	current_face = faces.pick_random()
	face_node.face_sprite.frame = current_face.pips
	await update()

func setup_visuals():
	pass
	
func update():
	face_node.face_sprite.frame = current_face.pips-1
		
func highlight():
	face_node.modulate = Color(1.0, 0.663, 1.0)


func return_dice():
	
	pass
	
func remove():
	
	print ("removing dice")
	used_this_turn = true
	visible = false

func destroy():
	
	pass

func _on_mouse_entered():
	
	InputManager.hovered_dice = self
	Global.world.hover_dice(self)
	
	#Global.animate(self,Enums.Anim.POP)
	#Global.animate(self,Enums.Anim.FLASH,Color.GREEN)
	
func _on_mouse_exited():
	if InputManager.hovered_dice == self:
		InputManager.hovered_dice = null
	Global.world.unhover_dice()
