extends Unit
class_name Hero

@onready var hp_label: Label = $Right_Stats/HBoxContainer/HP_Label
@onready var shield_label: Label = $Right_Stats/HBoxContainer/Shield_Label

@onready var unit_sprite: AnimatedSprite2D = $Unit_Sprite

var hp : int
var atk : int

func take_attack(amount : int, attacker: Unit):
	
	await ActionManager.request_action("damage_unit",{"amount" : amount, "damage_name" : "physical"},attacker.current_cell,current_cell)

func take_damage(amount : int):
	
	print ("was damaged")
	
	PlayerStats.player_hp = max(0,PlayerStats.player_hp-amount)
	update()
	if PlayerStats.player_hp < 1:
		
		Global.hero_unit.visible = false
		await Global.timer(1)
		Global.world.defeat()

func end_turn_effects():
	
	#REMOVE SHIELD AT TURN END

	if PlayerStats.status_effects.has("shield"):
		PlayerStats.status_effects.erase("shield")
	#ENACT EFFECTS HERE:
	
	if PlayerStats.status_effects.has("poison"):
		await ActionManager.create_action("damage_unit",{"damage_name" : "poison","amount":status_effects["poison"]},null,current_cell)
	
	#DECREASE OR ERASE EFFECTS HERE:
	
	var decreasing_effects := ["poison","burn","root","stun","invisible"]
	
	for x in decreasing_effects:
		if PlayerStats.status_effects.keys().has(x):
			if PlayerStats.status_effects[x] < 1:
				PlayerStats.status_effects.erase(x)
			else:
				PlayerStats.status_effects[x] -= 1
	
	update()

func update():
	
	if PlayerStats.status_effects.keys().has("shield"):
		if PlayerStats.status_effects["shield"] > 0:
			shield_label.visible = true
			shield_label.text = str("/",PlayerStats.status_effects["shield"])
		else:
			PlayerStats.status_effects.erase("shield")
			
	if not PlayerStats.status_effects.has("shield"): shield_label.visible = false
	
	hp_label.text = str(PlayerStats.player_hp)

	
	if current_cell != null:
		global_position = current_cell.global_position
	
