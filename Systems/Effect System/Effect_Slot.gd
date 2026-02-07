extends Node2D
class_name Effect_Slot

@onready var slot_color : ColorRect = $Slot_Color
@onready var slot_area: Area2D = $Slot_Area
@onready var effect_sprite: Sprite2D = $Effect_Sprite


var effect_name: String = ""

func _ready() -> void:
	
	slot_area.connect("mouse_entered", _on_mouse_entered)
	slot_area.connect("mouse_exited", _on_mouse_exited)

func fill_with_effect(new_effect_name : String):
	effect_name = new_effect_name
	var x_icon : CompressedTexture2D = load(str("res://Art/Effect_Sprites/",effect_name,".png"))
	effect_sprite.texture = x_icon
	
func clear_slot():
	
	effect_name = ""

func update():
	if effect_name != "":
		var x_icon : CompressedTexture2D = load(str("res://Art/Effect_Sprites/",effect_name,".png"))
		effect_sprite.texture = x_icon
	else:
		effect_sprite.texture = null
		
func _on_mouse_entered():
	
	if Global.game_state == Enums.GameState.PLAYER_TURN or Enums.GameState.SHOP:
		
		InputManager.hovered_effect_slot = self

func _on_mouse_exited():
	
	if Global.game_state == Enums.GameState.PLAYER_TURN or Enums.GameState.SHOP:
		if InputManager.hovered_effect_slot == self:
			InputManager.hovered_effect_slot = null

func is_empty() -> bool:
	
	var is_empty : bool
	if effect_name == null: is_empty = true
	else: is_empty = false
	
	return is_empty

	print("BLOBS")
