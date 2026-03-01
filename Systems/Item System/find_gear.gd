extends Control

var gear_name : String
@onready var gear_item: Control = $Item_Layer/GearItem
@onready var backpack_gear: Control = $backpack_gear

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	gear_item.take_button.connect("pressed",_on_take_pressed)
	gear_item.skip_button.connect("pressed",_on_skip_pressed)
	
	Global.back_gear_node = backpack_gear
	backpack_gear.load_backpack_gear()
	get_new_gear()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_new_gear():
	gear_name = GearManager.gear_data_dictionary.keys().pick_random()
	gear_item.setup_gear(gear_name)

func _on_take_pressed():
	if backpack_gear.empty_slots >= GearManager.gear_data_dictionary[gear_name]["gear_size"]:
		print ("gear taken")
		GearManager.backpack_gear.append(gear_name)
		print ("backpack gear array is now ", GearManager.backpack_gear)
		await backpack_gear.load_backpack_gear()
		Global.game_state = Enums.GameState.PLAYER_TURN
		queue_free()
		
	else:
		Global.float_text("NO ROOM", gear_item.global_position,Color.RED)
		
func _on_skip_pressed():
		Global.game_state = Enums.GameState.PLAYER_TURN
		queue_free()
