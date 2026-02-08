extends Node2D

@onready var slots_node: Node2D = $Slots_Node
@onready var item_layer: Node2D = $Item_Layer

var level_up_stats := {
"player_dex" : 1,
"player_int" : 1,
"player_str": 1,
"max_hp" : 3,
"move_points" : 1,
"crit_chance": 5 ,
"crit_damage" : 10,
"shield_bonus": 2
}

var all_slots : Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	all_slots = slots_node.get_children()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_new_level_ups():
	
	var level_stats = level_up_stats.keys().duplicate()
	
	for x in all_slots:
		
		var item = Level_Up.new()
		var stat = level_stats.pick_random()
		item.item_name = stat
		item.stat_name = stat
		item.stat_amount = level_up_stats[stat]
		x.fill_with_item(item)
		
func get_new_items():
	
	for x in all_slots:
		var item_pick = ItemManager.item_names.pick_random()
		var item_inst = ItemManager.get_new_item(item_pick)
		x.fill_with_item(item_inst)

func buy_item(item_slot: Item_Slot):
	print ("item purchased of ", item_slot.occupant.item_name)
	await item_slot.occupant.buy()
	await item_slot.clear_slot()
	item_slot.item_name_label.text = ""
