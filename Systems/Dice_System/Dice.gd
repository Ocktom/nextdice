extends Control
class_name Dice

@export var upgrade_slot_1: Effect_Slot
@export var upgrade_slot_2: Effect_Slot
@export var dice_icons_node : Node2D

var dice_icons : Array[Node]

var upgrade_slots : Array [Effect_Slot]

var faces : Array [Face]
var used_this_turn : bool :
	set(new_value):
		if used_this_turn != new_value: used_this_turn = new_value

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

@onready var face_sprite: Sprite2D = $Face_Node/Face_Sprite

@onready var upgrade_sprite: Sprite2D = $Effect_Sprite


var current_face : Face

func _ready() -> void:
	
	upgrade_slots = [upgrade_slot_1,upgrade_slot_2]
	
	Global.player_dice.append(self)
	
	dice_area.connect("mouse_entered",_on_mouse_entered)
	dice_area.connect("mouse_exited",_on_mouse_exited)
	
	for x in range(1,7):
			
		var y = Face.new()
		
		faces.append(y)
	
	print ("dice faces are", faces)

func use(action_source: Node, action_target: Node):
	
	print ("current_face.skill_name being used is ", current_face.skill_name)
	
	var skill_script : Skill = load(str("res://Systems/Skill_System/Skill_Scripts/skill_",current_face.skill_name,".gd")).new()
	await skill_script.execute(action_source,action_target,{})
	
	used_this_turn = true
	grey_out = true
	
	await Global.hero_unit.update()
	
func roll():
	
	current_face = faces.pick_random()
	print ("rolled current_face of ", current_face, " with skill of ", current_face.skill_name)
	await update()

func setup_visuals():
	pass
	
func update():

	face_sprite.texture =  load(str("res://Art/Skill_Sprites/",current_face.skill_name,".png"))
	
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
