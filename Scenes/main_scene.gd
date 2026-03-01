extends Control

var title_path : PackedScene = preload("res://Scenes/Title.tscn")
var world_path : PackedScene = preload("res://Scenes/world.tscn")
var inventory_path : PackedScene = preload("res://Systems/Inventory/Inventory_Screen.tscn")
var defeat_path : PackedScene = preload("res://Scenes/defeat.tscn")
var inventory_screen : Control

var current_scene: Node
var former_scene : Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Global.main = self
	load_scene(title_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_game():
	await DiceManager.reset()
	await load_scene(world_path,true)

func load_scene(scene: PackedScene, free_old_scene : bool = false):
	
	print ("loading scene")
	former_scene = current_scene
	var scene_inst = scene.instantiate()
	add_child(scene_inst)
	current_scene = scene_inst
	
	if free_old_scene:
		if former_scene != null:
			former_scene.queue_free()
	
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
