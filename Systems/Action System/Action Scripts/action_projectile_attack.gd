extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(context: Dictionary, action_source: Node = null, action_target: Node = null):
	
	print ("executing acttack action")
	var user = action_source
	var target = action_target.occupant
	
	var sprite_path := str("res://Art/Projectile_Sprites/",context["projectile_name"],".png")
	await Global.animate_projectile(action_source.global_position,action_target.global_position,sprite_path,true)
	await Global.timer(.3)
