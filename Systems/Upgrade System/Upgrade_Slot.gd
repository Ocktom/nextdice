extends Node2D
class_name Upgrade_Slot

@onready var slot_color : ColorRect = $Slot_Color
@onready var slot_area: Area2D = $Slot_Area
@onready var upgrade_sprite: Sprite2D = $Upgrade_Sprite


var upgrade_name: String = ""

func _ready() -> void:
	
	slot_area.connect("mouse_entered", _on_mouse_entered)
	slot_area.connect("mouse_exited", _on_mouse_exited)

func fill_with_upgrade(new_upgrade_name : String):
	upgrade_name = new_upgrade_name
	var x_icon : CompressedTexture2D = load(str("res://Art/Upgrade_Sprites/",upgrade_name,".png"))
	upgrade_sprite.texture = x_icon
	
func clear_slot():
	
	upgrade_name = ""

func update():
	if upgrade_name != "":
		var x_icon : CompressedTexture2D = load(str("res://Art/Upgrade_Sprites/",upgrade_name,".png"))
		upgrade_sprite.texture = x_icon
	else:
		upgrade_sprite.texture = null
		
func _on_mouse_entered():
	
	if Global.game_state == Enums.GameState.PLAYER_TURN or Enums.GameState.SHOP:
		
		InputManager.hovered_upgrade_slot = self

func _on_mouse_exited():
	
	if Global.game_state == Enums.GameState.PLAYER_TURN or Enums.GameState.SHOP:
		if InputManager.hovered_upgrade_slot == self:
			InputManager.hovered_upgrade_slot = null

func is_empty() -> bool:
	
	var is_empty : bool
	if upgrade_name == null: is_empty = true
	else: is_empty = false
	
	return is_empty

	print("BLOBS")
