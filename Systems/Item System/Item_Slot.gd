extends Node2D
class_name Item_Slot

@onready var slot_color : ColorRect = $Slot_Color
@onready var slot_area: Area2D = $Slot_Area

@onready var relic_sprite: Sprite2D = $Relic_Sprite
@onready var upgrade_sprite: Sprite2D = $Effect_Sprite
@onready var dice_sprite: AnimatedSprite2D = $Dice_Sprite

var dice_face_picked: Face

var occupant : Item

func _ready() -> void:
	
	slot_area.connect("mouse_entered", _on_mouse_entered)
	slot_area.connect("mouse_exited", _on_mouse_exited)

func clear_slot():
	Global.world.shop.item_layer.remove_child(occupant)
	occupant = null
	dice_face_picked = null
	
func fill_with_item(item : Item):
	
	occupant = item
	item.current_slot = self
	item.global_position = global_position
	Global.world.shop.item_layer.add_child(item)

func fill_with_upgrade(item : Item, dice_face : Face):
	
	occupant = item
	dice_face_picked = dice_face
	
	item.current_slot = self
	item.global_position = global_position
	Global.world.shop.item_layer.add_child(item)
	
	dice_sprite.frame = dice_face.pips-1
	print ("pips on item are ", dice_face.pips-1)
	dice_sprite.visible = true
	
	var sprite_path = str("res://Art/Effect_Sprites/",item.item_name,".png")
	print ("loading sprite of ", sprite_path)
	upgrade_sprite.texture = load(sprite_path)
	
	upgrade_sprite.visible = true
	relic_sprite.visible = false
	
func _on_mouse_entered():
	
	if Global.game_state == Enums.GameState.PLAYER_TURN or Enums.GameState.SHOP:
		
		print("cell hovered, occupant is ", occupant)
		InputManager.hovered_item_slot = self

func _on_mouse_exited():
	
	if Global.game_state == Enums.GameState.PLAYER_TURN or Enums.GameState.SHOP:
		if InputManager.hovered_item_slot == self:
			InputManager.hovered_item_slot = null

func is_empty() -> bool:
	
	var is_empty : bool
	if occupant == null: is_empty = true
	else: is_empty = false
	
	return is_empty
