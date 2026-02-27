extends Control

@onready var attack_section: Control = $HBoxContainer/attack_gear
@onready var movement_section: Control = $HBoxContainer/movement_gear
@onready var magic_section: Control = $HBoxContainer/magic_gear
@onready var backpack_section: Control = $backpack_gear

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	await set_slot_types()
	await load_equipped_gear()
	await backpack_section.load_backpack_gear()
	
	attack_section.bg_color.color = Color.CORAL
	movement_section.bg_color.color = Color.SEA_GREEN
	magic_section.bg_color.color = Color.CORNFLOWER_BLUE
	Global.inventory = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_slot_types():
	
	for slot in attack_section.gear_slots:
		slot.gear_slot_type = Enums.GearSlotType.ATTACK
	
	for slot in movement_section.gear_slots:
		slot.gear_slot_type = Enums.GearSlotType.MOVEMENT
		
	for slot in magic_section.gear_slots:
		slot.gear_slot_type = Enums.GearSlotType.MAGIC
		
	for slot in backpack_section.gear_slots:
		slot.gear_slot_type = Enums.GearSlotType.BACKPACK
	
func load_equipped_gear():
	
	GearManager.attack_skills = attack_section.load_gear(GearManager.attack_gear)
	GearManager.movement_skills = movement_section.load_gear(GearManager.movement_gear)
	GearManager.magic_skills = magic_section.load_gear(GearManager.magic_gear)
	
func parse_string_to_array(input: String) -> Array:
	var items = input.split(",")
	for i in range(items.size()):
		items[i] = items[i].strip_edges()
	return items

func insert_gear_from_slot(source_slot: GearSlot, target_slot: GearSlot):
	
	print("moving ", source_slot.gear_name, " to ", target_slot.gear_name)
	print ("target_slot gear slot typ ei s", target_slot.gear_slot_type)

	var source_gear_name = source_slot.gear_name
	var target_gear_name = target_slot.gear_name
	
	var target_skill_array: Array
	var target_gear_array: Array
	var target_gear_section : Control
	
	var source_gear_section
	var source_gear_array
	
	var source_gear_size = GearManager.gear_data_dictionary[source_gear_name]["gear_size"]
	var gear_type = GearManager.gear_data_dictionary[source_gear_name]["gear_type"]
	
	if target_slot.gear_slot_type != Enums.GearSlotType.BACKPACK:
		
		if target_slot.gear_slot_type != Enums.GearSlotType[gear_type]:
			Global.float_text("WRONG TYPE", target_slot.global_position,Color.RED)
			print ("gear inserted into wrong section, type mismatch")
			return
	
	match target_slot.gear_slot_type:
		
		Enums.GearSlotType.ATTACK:
			
			target_gear_array = GearManager.attack_gear
			target_gear_section = attack_section
			
		Enums.GearSlotType.MOVEMENT:

			target_gear_array = GearManager.movement_gear
			target_gear_section = movement_section
			
		Enums.GearSlotType.MAGIC:
			
			target_gear_section = magic_section
			target_gear_array = GearManager.magic_gear
			
		Enums.GearSlotType.BACKPACK:
			
			target_skill_array = []
			target_gear_array = GearManager.backpack_gear
			target_gear_section = backpack_section
	
	if not target_gear_section.empty_slots >= source_gear_size:
		Global.float_text("NO ROOM", target_slot.global_position,Color.RED)
		return
	
	if not target_slot.full:

		print("slot not full, source_gear size is ", source_gear_size, " target_section_empty slots is ", target_gear_section.empty_slots)
		if target_gear_section.empty_slots >= source_gear_size:

			target_gear_array.append(source_gear_name)
			
			#REMOVING ITEM FROM FORMER SLOT:
			
			match source_slot.gear_slot_type:
	
				Enums.GearSlotType.ATTACK:
					source_gear_array = GearManager.attack_gear

				Enums.GearSlotType.MOVEMENT:

					source_gear_array = GearManager.movement_gear
					
				Enums.GearSlotType.MAGIC:
					
					source_gear_array = GearManager.magic_gear
					
				Enums.GearSlotType.BACKPACK:
					
					source_gear_array = GearManager.backpack_gear
					
		var gear_ind = source_gear_array.find(source_gear_name)
		source_gear_array.remove_at(gear_ind)
	
	backpack_section.load_backpack_gear()
	load_equipped_gear()
