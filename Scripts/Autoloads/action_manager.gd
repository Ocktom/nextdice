extends Node

func destroy_enemy(unit : Unit):
	unit.current_cell.clear_cell()
	unit.queue_free()
	Global.world.victory_check()

func perform_enemy_action(action: Enums.EnemyAction, acting_enemy : Enemy):
	match action:
		
		Enums.EnemyAction.HEAL_ADJACENT:
			
			print ("heal adjacent called in actionmanger by ", acting_enemy.unit_name)
			
			var adjacent_cells = Global.grid.get_adjacent_cells(acting_enemy.current_cell)
			print ("adjacent cells received in actionmanager are ", adjacent_cells)
			for x in adjacent_cells:
				
				if x.occupant == null:
					continue
				if not x.occupant is Enemy:
					continue
				if x.occupant.hp == x.occupant.max_hp:
					continue
				
				heal_unit(x.occupant,3)
		
		Enums.EnemyAction.EMPOWER_ADJACENT:
			
			var adjacent_cells = Global.grid.get_adjacent_cells(acting_enemy.current_cell)
			for x in adjacent_cells:
				
				if x.occupant == null:
					continue
				if not x.occupant is Enemy:
					continue
				if x.occupant.hp == x.occupant.max_hp:
					continue
				
				empower_unit(x.occupant,3)
		

func heal_unit(unit : Unit, amount : int):
	unit.hp = max(unit.max_hp, unit.hp + amount)
	Global.animate(unit, Enums.Anim.FLASH,Color.GREEN_YELLOW)
	Global.float_text(str("+ ", amount),unit.global_position,Color.GREEN)
	unit.update_visuals()
	await Global.timer(.1)

func empower_unit(unit : Unit, amount : int):
	unit.turn_bonus += amount
