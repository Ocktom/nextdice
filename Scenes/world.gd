extends Node2D

@onready var card_layer : Node2D = $Card_Layer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Global.world = self
	Global.player_ui = $Player_UI
	Global.player_ui.update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reroll():
	if Global.rolls == 0:
		print ("no rolls left")
		return

	print ("rerolling")
	for x in Global.player_dice:
		if not x.used_this_turn: x.roll()
	
	Global.rolls -= 1
	Global.player_ui.update()

func end_turn():
	print ("TURN ENDED")

func hover_dice(dice : Dice):
	
	if dice.used_this_turn: return
	
	for x in Global.grid.all_cells:
		
		if x.occupant == null:
			continue
		
		if x.occupant.highlight: x.occupant.toggle_highlight()
		if x.occupant.slot_value == dice.current_face.pips:
			x.occupant.toggle_highlight()

func unhover_dice():
	
	for x in Global.grid.all_cells:
		if x.occupant == null: 
			continue
		if x.occupant.highlight: x.occupant.toggle_highlight()
