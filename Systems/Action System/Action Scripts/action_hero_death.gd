extends Action

var action_name := "hero_death"

func execute(context: Dictionary, action_source_cell: Cell = null, action_target_cell: Cell = null):
	
	
	print (" death executed")
	var target = action_source_cell.occupant
	
	if target.dying_this_turn : 
		print ("unit ", target.unit_name, " already dying this turn, exiting out of action_death script ")
		return
	
	target.dying_this_turn = true
	target.right_stats.visible = false
	target.unit_sprite.visible = false
	target.status_bar.visible = false

	await Global.world.defeat()
