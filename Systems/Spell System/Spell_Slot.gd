extends Node2D
class_name Spell_Slot

@onready var slot_color : ColorRect = $Slot_Color
@onready var slot_area: Area2D = $Slot_Area

var occupant : Spell

func _ready() -> void:
	slot_area.connect("mouse_entered", _on_mouse_entered)
	slot_area.connect("mouse_exited", _on_mouse_exited)

func spawn_unit(new_spell : Spell):

	Global.world.unit_layer.add_child(new_spell)
	await fill_with_spell(new_spell)

func clear_cell():
	
	occupant = null

func fill_with_spell(spell : Spell):
	
	occupant = spell
	spell.current_slot = self
	spell.global_position = global_position
	Global.world.unit_layer.add_child(spell)

func _on_mouse_entered():
	
	print("cell hovered, occupant is ", occupant)
	InputManager.hovered_spell_slot = self

	if not InputManager.dragging_dice == null:
		if not occupant == null:
			if occupant is Spell:
				if not occupant.highlight:
					occupant.toggle_highlight()

func _on_mouse_exited():
	
	if InputManager.hovered_spell_slot == self:
		InputManager.hovered_spell_slot = null
	
	if not occupant == null:
		if occupant.highlight:
			occupant.toggle_highlight()

func is_empty() -> bool:
	
	var is_empty : bool
	if occupant == null: is_empty = true
	else: is_empty = false
	
	return is_empty
