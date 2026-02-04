extends Control
class_name Dice

@export var upgrade_slot_1: Upgrade_Slot
@export var upgrade_slot_2: Upgrade_Slot

@export var dice_icons_node : Node2D

var dice_icons : Array[Node]

var upgrade_slots : Array [Upgrade_Slot]

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
	
	upgrade_slots = [upgrade_slot_1,upgrade_slot_2]
	
	dice_icons = dice_icons_node.get_children()
	
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
	
	print ("dice used, current face upgrade is ", current_face.upgrade)
	
func roll():
	
	#dice_color.color = Global.colors.pick_random()
	current_face = faces.pick_random()
	await update()

func setup_visuals():
	pass
	
func update():
	
	print ("updating dice current face, its upgrade dict is ", current_face.upgrade)
	face_node.face_sprite.frame = current_face.pips-1
	
	var upgrade = current_face.upgrade
	
	for x in upgrade.keys():
		print ("checking ", x, " in current_face.upgrade.keys in dice update_function")
		var x_icon : CompressedTexture2D = load(str("res://Art/Upgrade_Sprites/",x,".png")) 
		var icon = dice_icons[0] if dice_icons[0].texture == null else dice_icons[1]
		icon.texture = x_icon
	
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
