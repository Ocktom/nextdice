extends Node

var item_data_dictionary : Dictionary
var item_names : Array

func _ready() -> void:
	
	var item_data_script = load("res://Systems/Item System/item_data_dictionary.gd").new()
	item_data_dictionary = item_data_script.data
	item_names = item_data_dictionary.keys()

func get_new_item(item_name : String):
	print("inserting item")

	var item_data = item_data_dictionary[item_name]
	var item_path : PackedScene = preload("res://Systems/item System/Item.tscn")
	var item_inst = item_path.instantiate()

	print("item data being inserted is ", item_data)

	item_inst.item_name = item_name
	item_inst.item_cost = item_data["item_cost"]
	item_inst.item_type = Enums.ItemType[item_data["item_type"]]
	item_inst.description = item_data["description"]
	
	return item_inst

func get_upgrade_names() -> Array[String]:
	var upgrade_names : Array[String] = []
	for x in item_names:
		if Enums.ItemType[ItemManager.item_data_dictionary[x]["item_type"]] == Enums.ItemType.UPGRADE:
			upgrade_names.append(x)
	print ("get_upgrade_names returns ", upgrade_names)
	return upgrade_names
