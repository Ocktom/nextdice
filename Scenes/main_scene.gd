extends Control

var title_path : PackedScene = preload("res://Scenes/Title.tscn")
var world_path : PackedScene = preload("res://Scenes/world.tscn")
var inventory_path : PackedScene = preload("res://Systems/Inventory/Inventory_Screen.tscn")

var inventory_screen : Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	load_scene(title_path)
	Global.main = self
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_game():
	await load_scene(world_path)

func load_scene(scene: PackedScene):
	
	var scene_inst = scene.instantiate()
	add_child(scene_inst)

func enter_inventory_screen():
	print ("inventory_screen")
	Global.game_state = Enums.GameState.INVENTORY
	await load_scene(inventory_path)

func resume_game():
	
	print ("game resuming")
	
	match Global.game_state:
		Enums.GameState.INVENTORY:
			Global.inventory.queue_free()
			Global.game_state = Enums.GameState.PLAYER_TURN
