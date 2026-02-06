extends Unit
class_name Hero

@onready var hp_label: Label = $Right_Stats/HP_Label
@onready var atk_label: Label = $Right_Stats/ATK_Label

@onready var icon_1_sprite: Sprite2D = $Left_Stats/MarginContainer/icon_1_sprite
@onready var icon_2_sprite: Sprite2D = $Left_Stats/MarginContainer2/icon_2_sprite
@onready var icon_3_sprite: Sprite2D = $Left_Stats/MarginContainer3/icon_3_sprite
@onready var icon_4_sprite: Sprite2D = $Left_Stats/MarginContainer4/icon_4_sprite

@onready var unit_sprite: AnimatedSprite2D = $Unit_Sprite


func take_attack(amount : int):
	
	var shield : int = 0
	
	if status_effects.has("shield"):
		shield = status_effects["shield"]
	
	print("shield is ", shield)
	
	Global.animate(self,Enums.Anim.SHAKE)
	Global.animate(self,Enums.Anim.FLASH,Color.RED)
	
	
	Global.player_hp = max(0,Global.player_hp - amount)
	update()
	Global.player_ui.update()
	Global.float_text(str("-", amount),self.global_position,Color.RED)
	await Global.timer(.2)

func take_non_attack_damage(amount : int):
	
	print ("was damaged")
	
	Global.player_hp = max(0,Global.player_hp-amount)
	update()
	if Global.player_hp < 1:
		
		await Global.timer(1)
		Global.world.defeat()

func end_turn_effects():
	
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
	
	unit_name_label.text = str(unit_name)
	hp_label.text = str(Global.player_hp)
	
	var status_icons : Array = [icon_1_sprite,icon_2_sprite,icon_3_sprite,icon_4_sprite]
	
	for x in status_icons:
		x.visible = false
		x.texture = null
	
	for x in status_effects.keys():
		var ind = status_effects.keys().find(x)
		status_icons[ind].texture = load(str("res://Art/Icon_Sprites/icon_",x,".png"))
		status_icons[ind].visible = true
