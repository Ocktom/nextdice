extends Unit
class_name Hero

@onready var hp_label: Label = $Right_Stats/HBoxContainer/HP_Label
@onready var shield_label: Label = $Right_Stats/HBoxContainer/Shield_Label

@onready var icon_1_sprite: Sprite2D = $Left_Stats/MarginContainer/icon_1_sprite
@onready var icon_2_sprite: Sprite2D = $Left_Stats/MarginContainer2/icon_2_sprite
@onready var icon_3_sprite: Sprite2D = $Left_Stats/MarginContainer3/icon_3_sprite
@onready var icon_4_sprite: Sprite2D = $Left_Stats/MarginContainer4/icon_4_sprite

@onready var unit_sprite: AnimatedSprite2D = $Unit_Sprite

var hp : int
var atk : int

func take_attack(amount : int):
	
	var shield : int = 0
	
	if status_effects.has("shield"):
		shield = status_effects["shield"]
	
		if amount <= shield:
			status_effects["shield"] -= amount
			Global.animate(self,Enums.Anim.SHAKE)
			Global.animate(self,Enums.Anim.FLASH)
			Global.audio_node.play_sfx("res://Audio/Sound_Effects/DSGNMisc_HIT-Spell Hit_HY_PC-001.wav")
			await update()
			return
		
		if amount > shield:
			
			PlayerStats.player_hp = max(0,PlayerStats.player_hp - (amount-shield))
			Global.animate(self,Enums.Anim.SHAKE)
			Global.animate(self,Enums.Anim.FLASH,Color.RED)
			await update()
			return
	else:
		
		Global.animate(self,Enums.Anim.SHAKE)
		Global.animate(self,Enums.Anim.FLASH,Color.RED)
		
		PlayerStats.player_hp = max(0,PlayerStats.player_hp - amount)
		update()
		Global.player_ui.update()
		Global.float_text(str("-", amount),self.global_position,Color.RED)
		await Global.timer(.2)

func take_damage(amount : int):
	
	print ("was damaged")
	
	PlayerStats.player_hp = max(0,PlayerStats.player_hp-amount)
	update()
	if PlayerStats.player_hp < 1:
		
		await Global.timer(1)
		Global.world.defeat()

func end_turn_effects():
	
	#REMOVE SHIELD AT TURN END

	if status_effects.has("shield"):
		status_effects.erase("shield")
	#ENACT EFFECTS HERE:
	
	if status_effects.has("poison"):
		await ActionManager.create_action("damage_unit",{"damage_name" : "poison","amount":status_effects["poison"]},null,self)
	
	#DECREASE OR ERASE EFFECTS HERE:
	
	var decreasing_effects := ["poison","burn","root","stun","invisible"]
	
	for x in decreasing_effects:
		if status_effects.keys().has(x):
			if status_effects[x] < 1:
				status_effects.erase(x)
			else:
				status_effects[x] -= 1
	
	update()

func update():
	
	if status_effects.keys().has("shield"):
		if status_effects["shield"] > 0:
			shield_label.visible = true
			shield_label.text = str("/",status_effects["shield"])
		else:
			status_effects.erase("shield")
			
	if not status_effects.has("shield"): shield_label.visible = false
	
	unit_name_label.text = str(unit_name)
	hp_label.text = str(PlayerStats.player_hp)
	
	var status_icons : Array = [icon_1_sprite,icon_2_sprite,icon_3_sprite,icon_4_sprite]
	
	for x in status_icons:
		x.visible = false
		x.texture = null
	
	for x in status_effects.keys():
		var ind = status_effects.keys().find(x)
		status_icons[ind].texture = load(str("res://Art/Icon_Sprites/icon_",x,".png"))
		status_icons[ind].visible = true
	
	if current_cell != null:
		global_position = current_cell.global_position
	
