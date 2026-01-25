extends Unit
class_name Hero

func take_attack(amount : int):
	Global.float_text(str("-", amount),self.global_position,Color.RED)
	Global.animate(self,Enums.Anim.SHAKE)
	Global.animate(self,Enums.Anim.FLASH,Color.RED)
	Global.player_hp = max(0,Global.player_hp - amount)
	update_visuals()
	Global.player_ui.update()

func update_visuals():
	
	unit_name_label.text = str(unit_name)
	hp_label.text = str(Global.player_hp)
