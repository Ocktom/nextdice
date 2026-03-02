extends Control

@onready var area_1: Area2D = $Area_1
@onready var area_2: Area2D = $Area_2
@onready var area_3: Area2D = $Area_3

@onready var skill_grid: GridContainer = $Skill_Grid

@onready var skill_texture_1: TextureRect = $Skill_Grid/skill_texture_1
@onready var skill_texture_3: TextureRect = $Skill_Grid/skill_texture_3
@onready var skill_texture_5: TextureRect = $Skill_Grid/skill_texture_5
@onready var skill_texture_2: TextureRect = $Skill_Grid/skill_texture_2
@onready var skill_texture_4: TextureRect = $Skill_Grid/skill_texture_4
@onready var skill_texture_6: TextureRect = $Skill_Grid/skill_texture_6

@onready var gear_slot_1: GearSlot = $HBoxContainer/Gear_Slot_1
@onready var gear_slot_2: GearSlot = $HBoxContainer/Gear_Slot2
@onready var gear_slot_3: GearSlot = $HBoxContainer/Gear_Slot3



var gear_slots : Array[GearSlot]
var skill_textures : Array
var empty_slots := 0

@onready var bg_color: ColorRect = $BG_color


func _ready() -> void:
	print ("Loading gear")
	
	gear_slots = [gear_slot_1,gear_slot_2,gear_slot_3]
	skill_textures = [
		skill_texture_1,skill_texture_2,skill_texture_3,skill_texture_4,skill_texture_5,skill_texture_6]
	
	load_gear(GearManager.attack_gear)

func load_gear(gear_name_array: Array[String]) -> Array[String]:
	
	print("Loading gear")

	var skills_array : Array[String] = []

	# sort gear using the new function
	var sorted_gear = sort_gear_by_size(gear_name_array)

	for gear_name in sorted_gear:
		var gear_skills_string : String = ItemManager.gear_data_dictionary[gear_name]["skills"]
		var gear_skills = parse_string_to_array(gear_skills_string)

		for skill in gear_skills:
			skills_array.append(skill)

	print("gear skills array is ", skills_array)

	await fill_gear_slots(sorted_gear)
	await fill_skill_textures(skills_array)
	await update_capacity()
	return skills_array

func update_capacity():
	print ("updating backpack capacity")
	empty_slots = 3
	print ("starting empty slots is", empty_slots)

	for slot in gear_slots:
		if slot.full:
			empty_slots -= 1
	
	print ("ending empty slots is", empty_slots)

func fill_gear_slots(sorted_gear: Array[String]) -> void:

	# clear slots
	for slot in gear_slots:
		slot.gear_texture.texture = null
		slot.gear_name = ""
		slot.extending_slot = null
		slot.full = false

	var slot_index = 0

	for gear_name in sorted_gear:

		if slot_index >= gear_slots.size():
			break

		var gear_size : int = ItemManager.gear_data_dictionary[gear_name]["gear_size"]
		var tex = load("res://Art/Gear_Sprites/" + gear_name + ".png")

		# primary slot
		var primary = gear_slots[slot_index]
		primary.gear_texture.texture = tex
		primary.gear_name = gear_name
		primary.extending_slot = null
		primary.full = true

		# size 2 gear extends into next slot
		if gear_size == 2 and slot_index + 1 < gear_slots.size():

			var extension = gear_slots[slot_index + 1]
			extension.gear_texture.texture = null
			extension.gear_name = gear_name
			extension.extending_slot = primary
			extension.full = true

			slot_index += 2
		else:
			slot_index += 1

func sort_gear_by_size(gear_array: Array[String]) -> Array[String]:
	var sorted = gear_array.duplicate()
	sorted.sort_custom(func(a, b):
		var size_a = ItemManager.gear_data_dictionary[a]["gear_size"]
		var size_b = ItemManager.gear_data_dictionary[b]["gear_size"]
		return size_a > size_b
	)
	return sorted

func fill_skill_textures(skill_array: Array[String]) -> void:

	# clear existing textures
	for tex in skill_textures:
		tex.texture = null

	for i in range(skill_array.size()):

		if i >= skill_textures.size():
			break

		var skill_name = skill_array[i]
		skill_textures[i].texture = load("res://Art/Skill_Sprites/" + skill_name + ".png")
# Called every frame. 'delta' is the elapsed time since the previous frame.

func parse_string_to_array(input: String) -> Array:
	var items = input.split(",")
	for i in range(items.size()):
		items[i] = items[i].strip_edges()
	return items
