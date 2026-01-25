extends Node2D
class_name Spell

var target_type : Enums.TargetType :
	set(new_value):
		target_type = new_value
		print ("target type on spell set to ", new_value)
		
var spell_name : String

var value_1 : int
var value_2 : int

var mana_cost := 5
var cooldown := 2

var highlight := false
var current_slot : Spell_Slot
var sprite_path : String

var border_color : Color = Color.WHITE
var normal_color : Color = Color.BLACK

var selected_target : Node2D
var damaged := false

@onready var background_rect: ColorRect = $Background_Rect

@onready var spell_name_label : Label = $Spell_Name_Label
@onready var cost_label: Label = $Cost_Label

@onready var border_rect: ColorRect = $border_rect

func _ready():
	update()

	
func use_spell():
	
	print ("use_spell started...")
	Global.world.spell_ui.spend_mana(mana_cost)
	
	#MATCH SPELLS THAT DO -NOT- NEED SELECTION FIRST
	match target_type:
		Enums.TargetType.SELF:
			cast_on_target(Global.hero_unit)
			return
	
	SpellManager.selection_complete.connect(_on_target_selected)
	
	match target_type:
		Enums.TargetType.SELECT_UNIT:
			print ("target type is select_unit")
			SpellManager.select_unit(self)
		Enums.TargetType.SELECT_CELL:
			print ("target type is select_cell")
			SpellManager.select_cell(self)
		
func _on_target_selected(target: Node2D):
	print (" Spell got target of ", target, " casting now!")
	SpellManager.selection_complete.disconnect(_on_target_selected)
	cast_on_target(target)

func cast_on_target(target: Node2D):
	print ("cast_on_target cast on target ", target, ", matching spell name of ", spell_name)
	match spell_name:
		"Fireball":
			print ("fireball matched")
			target.take_attack(value_1)
			Global.float_text("FIREBALL",target.global_position,Color.ORANGE)
		"Lightning Bolt":
			print ("lightning matched")
			target.take_attack(value_1)
			target.take_attack(value_1)
			Global.float_text("BOLT",target.global_position,Color.SKY_BLUE)
		"Heal":
			print ("heal matched")
			Global.float_text("HEAL",target.global_position,Color.LAWN_GREEN)
			Global.player_hp = min (Global.max_hp, Global.player_hp + value_1)
		"Poison Cloud":
			target.poison = true
			Global.float_text("POISON",target.global_position,Color.LAWN_GREEN)
		
		
func update():
	
	var spell_type = Enums.SpellType.values().pick_random()
	spell_name_label.text = spell_name
		
func toggle_highlight():
	if highlight:
		highlight = false
		border_rect.visible = false
	else:
		highlight = true
		border_rect.visible = true
