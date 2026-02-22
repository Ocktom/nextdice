extends Node

var numbered_status_effects: Array[String] = [
		"burn","frost","poison","spikes"
		]
var decreasing_status_effects: Array[String] = [
	"frost","poison","burn","regrow"
]
var auto_remove_status_effects: Array[String] = [
		"frost","poison","burn","shield"]

var no_icon_status_effects : Array[String] = ["shield"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_turn_effects(unit: Unit):
		
	if unit.status_effects.has("shield"):
		unit.status_effects["shield"] = 0

func end_turn_effects(unit : Unit):
	
	print ("end_turn effects for ", unit.unit_name)
	
	#if not is_instance_valid(unit) : return
	
	if unit.current_cell.cell_effect == Enums.CellEffect.FIRE:
		unit.status_effects["burn"] = 3
	
	if not is_instance_valid(unit) : 
		print ("instance invalid after FIRE, returning")
		return
	
	
	if unit.status_effects.has("burn"):
		print ("unit has burn, applying...")
		await ActionManager.request_action("damage_unit",{"damage_name" : "fire", "amount": 1}
		,unit.current_cell,unit.current_cell)
	
	if not is_instance_valid(unit) : 
		print ("instance invalid after burn, returning")
		return
	
	if unit.status_effects.has("poison"):
		print ("unit has poison, applying...")
		await ActionManager.request_action("damage_unit",{"damage_name" : "poison", "amount": 1}
		,unit.current_cell,unit.current_cell)
	
	if not is_instance_valid(unit) : 
		print ("instance invalid after poison, returning")
		return
	
	if unit.status_effects.keys().has("regrow"):
		print ("unit has regrow, with a value of ", unit.status_effects["regrow"] )
		if unit.status_effects["regrow"] < 1:
			print ("REGROWING")
			var cell_pick = unit.current_cell
			await ActionManager.request_action("transform_unit",{"unit_name": "Skeltron"},cell_pick,cell_pick)
	
	if not is_instance_valid(unit) : 
		print ("instance invalid after regrow, returning")
		return
		
	for x in decreasing_status_effects:
		if unit.status_effects.keys().has(x):
			
			unit.status_effects[x] -= 1
	
	for x in auto_remove_status_effects:	
		if unit.status_effects.keys().has(x):
			if unit.status_effects[x] < 1:
				unit.status_effects.erase(x)
				if not no_icon_status_effects.has(x):
					for y in unit.status_bar.get_children():
						if y.status_name == x: y.queue_free()
						
	print ("regrow at end is ", )
	
	await unit.update()
	
func update_status_effects(unit : Unit):
	
	if not is_instance_valid(unit) : 
		print ("instance invalid in update, returning")
		return
	
	if unit.status_effects.keys().has("frost"):
		if unit.status_effects["frost"] >= 3:
			unit.status_effects.erase("frost")
			ActionManager.request_action("status_effect",{"status_name" : "FREEZE", "amount" : 1},unit.current_cell,unit.current_cell)
	
	if not is_instance_valid(unit) : return
	
	if unit.status_effects.keys().has("freeze"):
		
		if unit.status_effects.has("frost"): unit.status_effects.erase("frost")
		
		if not unit.frozen:
			unit.frozen = true
			
			Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNTonl_MELEE-Sword Critical_HY_PC-002.wav")
			Global.animate(self,Enums.Anim.FLASH,Color.AQUA)
			await Global.timer(.2)
			
			unit.current_cell.cell_effect = Enums.CellEffect.NONE
			unit.current_cell.update()
			
			unit.sprite_ov.texture = load("res://Art/icy_cell.png")
			unit.sprite_ov.visible = true
			unit.unit_sprite.stop()
			unit.unit_sprite.frame = 0
	
	if not is_instance_valid(unit) : return
	
	for x in unit.status_effects.keys():
		
		if not no_icon_status_effects.has(x):
			
			var status_icons = unit.status_bar.get_children()
			
			var status_icon : StatusIcon = null
			for y in status_icons:
				if y.status_name == x:
					status_icon = y
			
			if status_icon == null:
				var icon_path : PackedScene = preload("res://Systems/Player_UI/status_icon.tscn")
				var icon_inst = icon_path.instantiate()
				unit.status_bar.add_child(icon_inst)
				status_icon = icon_inst
				status_icon.status_name = x
				status_icon.icon_texture.texture = load(str("res://Art/Status_Sprites/icon_",x,".png"))
				
			if numbered_status_effects.has(x):
				status_icon.value_label.text = str(unit.status_effects[x])
			
	if unit.status_effects.keys().has("invisible"):
		unit.unit_sprite.modulate = Color(1.0, 1.0, 1.0, 0.424)
	else:
		unit.unit_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)

	var shield_val = unit.status_effects.get("shield", 0)

	if shield_val > 0:
		unit.shield_label.visible = true
		unit.shield_label.text = str("/", shield_val)
	else:
		unit.shield_label.visible = false
		unit.shield_label.text = ""
