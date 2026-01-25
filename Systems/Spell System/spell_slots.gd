extends Node2D

var spell_slots : Array[Node]
@onready var mana_node: Node2D = $Mana
@onready var mana_area: Area2D = $Mana/Mana_Area
@onready var mana_label: Label = $Mana/Mana_Label
@onready var spell_slots_node : Node2D = $Spell_Slots

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	spell_slots = spell_slots_node.get_children()
	mana_area.connect("mouse_entered",_on_mana_area_entered)
	mana_area.connect("mouse_exited",_on_mana_area_exited)
	update()
	
func create_new_spells():

	for x in spell_slots:
		var spell_path : PackedScene = preload("res://Systems/Spell System/Spell.tscn")
		var spell_inst = spell_path.instantiate()
		x.fill_with_spell(spell_inst)
	
func update():
	mana_label.text = str(Global.mana)

func add_mana(amount : int):
	Global.mana = min(Global.max_mana,Global.mana + amount)
	update()
	
func spend_mana(amount : int):
	Global.animate(mana_node,Enums.Anim.FLASH,Color.AQUA)
	Global.mana = max(0,Global.mana - amount)
	update()

func _on_mana_area_entered():
	print("mana area hovered")
	InputManager.mana_area_hovered = true

func _on_mana_area_exited():
	print("mana area un-hovered")
	InputManager.mana_area_hovered = false
