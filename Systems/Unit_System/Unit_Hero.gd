extends Unit
class_name Hero

@onready var hp_label: Label = $Right_Stats/HBoxContainer/HP_Label
@onready var shield_label: Label = $Right_Stats/HBoxContainer/Shield_Label
@onready var unit_sprite: AnimatedSprite2D = $Unit_Sprite
@onready var right_stats: VBoxContainer = $Right_Stats


func end_turn_effects():
	
	#REMOVE SHIELD AT TURN END

	if Global.player_stats.status_effects.has("shield"):
		Global.player_stats.status_effects.erase("shield")
	#ENACT EFFECTS HERE:
	
	if Global.player_stats.status_effects.has("poison"):
		await ActionManager.create_action("damage_unit",{"damage_name" : "poison","amount":status_effects["poison"]},null,current_cell)
	
	#DECREASE OR ERASE EFFECTS HERE:
	
	var decreasing_effects := ["poison","burn","root","stun","invisible"]
	
	for x in decreasing_effects:
		if Global.player_stats.status_effects.keys().has(x):
			if Global.player_stats.status_effects[x] < 1:
				Global.player_stats.status_effects.erase(x)
			else:
				Global.player_stats.status_effects[x] -= 1
	
	update()

func update():
	
	if Global.player_stats.status_effects.keys().has("shield"):
		if Global.player_stats.status_effects["shield"] > 0:
			shield_label.visible = true
			shield_label.text = str("/",Global.player_stats.status_effects["shield"])
		else:
			Global.player_stats.status_effects.erase("shield")
			
	if not Global.player_stats.status_effects.has("shield"): shield_label.visible = false
	
	hp_label.text = str(Global.player_stats.player_hp)

	
	if current_cell != null:
		global_position = current_cell.global_position
	
