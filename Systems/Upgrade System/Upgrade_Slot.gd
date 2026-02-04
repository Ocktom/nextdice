extends Node2D
class_name Upgrade_Slot

@onready var slot_color : ColorRect = $Slot_Color
@onready var slot_area: Area2D = $Slot_Area

var occupant : Upgrade

func _ready() -> void:
	
	slot_area.connect("mouse_entered", _on_mouse_entered)
	slot_area.connect("mouse_exited", _on_mouse_exited)

func clear_slot():
	Global.world.shop.item_layer.remove_child(occupant)
	occupant = null
	
func fill_with_item(upgrade : Upgrade):
	
	occupant = upgrade
	upgrade.current_slot = self
	upgrade.global_position = global_position
	Global.world.shop.item_layer.add_child(upgrade)

func _on_mouse_entered():
	
	if Global.game_state == Enums.GameState.PLAYER_TURN or Enums.GameState.SHOP:
		
		print("cell hovered, occupant is ", occupant)
		InputManager.hovered_upgrade_slot = self

func _on_mouse_exited():
	
	if Global.game_state == Enums.GameState.PLAYER_TURN or Enums.GameState.SHOP:
		if InputManager.hovered_item_slot == self:
			InputManager.hovered_item_slot = null

func is_empty() -> bool:
	
	var is_empty : bool
	if occupant == null: is_empty = true
	else: is_empty = false
	
	return is_empty
