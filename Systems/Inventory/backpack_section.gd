extends Control

var gear_slots : Array
var empty_slots := 0
@onready var backpack_hbox: HBoxContainer = $Backpack_Hbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gear_slots = backpack_hbox.get_children()
	print ("gear slots are ", gear_slots)

func load_backpack_gear() -> void:
	print ("loading backpack gear")
	# get all backpack gear
	var gear_array : Array[String] = GearManager.backpack_gear.duplicate()
	
	# clear backpack slots first
	for slot in gear_slots:
		slot.gear_texture.texture = null
		slot.gear_name = ""
		slot.extending_slot = null
		slot.full = false
	
	# sort large gear first
	gear_array.sort_custom(func(a, b):
		var size_a = GearManager.gear_data_dictionary[a]["gear_size"]
		var size_b = GearManager.gear_data_dictionary[b]["gear_size"]
		return size_a > size_b
	)
	
	var slot_index = 0
	
	for gear_name in gear_array:
	
		var gear_size : int = GearManager.gear_data_dictionary[gear_name]["gear_size"]
		var tex = load("res://Art/Gear_Sprites/" + gear_name + ".png")
		
		# fill primary slot
		var primary_slot = gear_slots[slot_index]
		primary_slot.gear_texture.texture = tex
		primary_slot.gear_name = gear_name
		primary_slot.extending_slot = null  # primary slot has no extending slot
		primary_slot.full = true
		
		# if size 2 → mark next slot as extending_slot
		if gear_size == 2 and slot_index + 1 < gear_slots.size():
			var extending_slot = gear_slots[slot_index + 1]
			extending_slot.gear_texture.texture = null
			extending_slot.gear_name = gear_name
			extending_slot.extending_slot = primary_slot  # points back to primary
			extending_slot.full = true
			slot_index += 2
			
		else:
			
			slot_index += 1
	update_capacity()
	
func update_capacity():
	print ("updating backpack capacity")
	empty_slots = 8
	print ("starting empty slots is", empty_slots)

	for slot in gear_slots:
		if slot.full:
			empty_slots -= 1
	
	print ("ending empty slots is", empty_slots)
	
		
