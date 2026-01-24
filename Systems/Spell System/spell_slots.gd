extends Node2D

var spell_slots : Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spell_slots = get_children()
	
func create_new_spells():

	for x in spell_slots:
		var spell_path : PackedScene = preload("res://Systems/Spell System/Spell.tscn")
		var spell_inst = spell_path.instantiate()
		x.fill_with_spell(spell_inst)
	
func _process(delta: float) -> void:
	pass
