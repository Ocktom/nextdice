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

func get_new_upgrades():
	
	var all_upgrades = ItemManager.get_upgrade_names()
	for x in all_slots:
		var upgrade_pick = all_upgrades.pick_random()
		all_upgrades.erase(upgrade_pick)
		var ind = all_slots.find(x)
		
		var item_inst = ItemManager.get_new_item(upgrade_pick)
		
		var face_pick = Global.player_dice[ind].faces.pick_random()
		
		x.fill_with_upgrade(item_inst, face_pick)

func buy_item(item_slot: Item_Slot):
	print ("item purchased of ", item_slot.occupant.item_name)
	match item_slot.occupant.item_type:
		Enums.ItemType.UPGRADE:
			print ("UPGRADE type matched in buy_item")
			UpgradeManager.insert_upgrade(item_slot.occupant.item_name,item_slot.dice_face_picked)
	
	item_slot.clear_slot()
