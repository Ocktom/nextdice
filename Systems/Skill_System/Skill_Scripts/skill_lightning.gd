extends Skill

var range := 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute(action_source: Node, target: Node, context:= {}):
	
	var target_unit = target.occupant
	var amount = 3
	
	var hit_units : Array[Unit] = []
	var current_unit : Unit = target_unit
	
	var source_cell : Cell = Global.hero_unit.current_cell
	
	while current_unit != null and amount > 0:
		#Global.animate_projectile(source_cell.global_position,current_unit.global_position,"res://Art/Projectile_Sprites/fireball.png",true)
		if source_cell.occupant != Global.hero_unit:
			Global.animate_lightning(source_cell,current_unit.current_cell)
		await Global.timer(.3)
		print ("current unit is ", current_unit)
		Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNMisc_MELEE-Bit Sword_HY_PC-001.wav")
		await ActionManager.request_action("damage_unit",{"amount" : amount,"damage_name" : "lightning"},action_source,current_unit.current_cell)
		hit_units.append(current_unit)
		amount -= 1

		if amount <= 0:
			print ("lightning ran out of damage")
			return

		var next_unit : Unit = null
		var adj_cells = Global.grid.get_adjacent_cells(current_unit.current_cell)

		for cell in adj_cells:
			if cell.occupant != null and not hit_units.has(cell.occupant):
				next_unit = cell.occupant
				break
		
		source_cell = current_unit.current_cell
		current_unit = next_unit
