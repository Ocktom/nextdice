extends Node2D
class_name Unit

@onready var unit_sprite: AnimatedSprite2D = $Unit_Sprite

var current_cell: Cell
var unit_name : String = "Unit"
@onready var status_bar: GridContainer = $Status_Bar

var status_icons : Array[Node]

var highlight := false
var range_type : Enums.RangeType

var unit_passives : Dictionary

var dying_this_turn := false

var status_effects : Dictionary = {}

@onready var unit_name_label : Label = $Unit_Name_Label
@onready var effects_sprite: AnimatedSprite2D = $Effects_Sprite

func _ready():
	
	print ("unit passives for ", unit_name, " is ", unit_passives)
	Global.all_units.append(self)
	await update()

func destroy(overkill := false):
	
	pass

func remove():
	
	print ("disuniting!")
	await Global.animate(self,Enums.Anim.SQUISH)
	await Global.timer(.07)
	visible = false
	await Global.float_text("DISCARDED",position,Color.ROSY_BROWN)
	Global.all_units.erase(self)
	await current_cell.clear_cell()
	
	queue_free()

func apply_destroy_effects():
	
	pass

func assign_to_cell(cell: Cell) -> void:
	
	if current_cell != null:
		current_cell.occupant = null

	current_cell = cell
	current_cell.occupant = self
	position = current_cell.global_position

func update():
	
	pass

func get_grid_position() -> Vector2i:
	
	if current_cell != null:
		return current_cell.grid_position
	return Vector2i(-1, -1)
		
func _on_mouse_entered():
	
	InputManager.hovered_unit = self

func _on_mouse_exited():
	if InputManager.hovered_unit == self:
		InputManager.hovered_unit = null

func shake_sprite():
	if not is_instance_valid(unit_sprite):
		return

	unit_sprite.position = Vector2.ZERO

	var tween = unit_sprite.create_tween()
	var strength = 10
	var shakes = 3
	var time = 0.2

	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	for i in range(shakes):
		var dir = -1 if i % 2 == 0 else 1
		tween.tween_property(
			unit_sprite,
			"position",
			Vector2(strength * dir, 0),
			time / shakes
		)

	tween.tween_property(unit_sprite, "position", Vector2.ZERO, 0.05)
	
func flash_sprite(flash_color: Color):
	if not is_instance_valid(unit_sprite):
		return

	unit_sprite.modulate = Color(1,1,1,1)

	var tween = unit_sprite.create_tween()
	var flash = flash_color * 2.0
	flash.a = 1.0

	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(unit_sprite, "modulate", flash, 0.08)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(unit_sprite, "modulate", Color(1,1,1,1), 0.12)

func dart_sprite_to_global(global_target: Vector2):
	if not is_instance_valid(unit_sprite):
		return

	unit_sprite.position = Vector2.ZERO

	# Convert global target into the sprite’s parent local space
	var local_target = unit_sprite.get_parent().to_local(global_target)

	# Offset relative to unit's own origin
	var offset = local_target - unit_sprite.get_parent().to_local(global_position)

	# Clamp distance if you only want a short dart
	var max_distance = 100
	if offset.length() > max_distance:
		offset = offset.normalized() * max_distance

	var tween = unit_sprite.create_tween()

	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(unit_sprite, "position", offset, 0.08)

	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(unit_sprite, "position", Vector2.ZERO, 0.1)
