extends Node2D

@onready var slots_node: Node2D = $Slots_Node
@onready var item_layer: Node2D = $Item_Layer

var all_slots : Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	all_slots = slots_node.get_children()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_new_items():
	
	for x in all_slots:
		var item_pick = ItemManager.item_names.pick_random()
		var item_inst = ItemManager.get_new_item(item_pick)
		x.fill_with_item(item_inst)

func buy_item(item_slot: Item_Slot):
	print ("item purchased of ", item_slot.occupant.item_name)
	item_slot.clear_slot()
