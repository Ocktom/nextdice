extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	print ("executing acttack action")
	
	var sprite_path := str("res://Art/Projectile_Sprites/",context["projectile_name"],".png")
	await Global.animate_projectile(action_source_cell.global_position,action_target_cell.global_position,sprite_path,true)
	await Global.timer(.3)
