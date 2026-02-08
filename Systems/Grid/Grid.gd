extends Node2D

const GRID_WIDTH = 5
const GRID_HEIGHT = 4
const CELL_SIZE = Vector2(210, 210)
var CELL_SPACING = Vector2(6, 6)
var CellScene = preload("res://Systems/Grid/Cell.tscn")

@onready var units_node: Node2D = $Units
@onready var grid_marker: Marker2D = $Grid_Marker

var grid: Array = []          # WILL BE grid[x][y]
var all_cells: Array[Cell]

func _ready():
	
	Global.grid = self
	await create_grid()

func create_grid():
	var start_pos = grid_marker.position
	
	grid.clear()
	all_cells.clear()

	# Create outer array sized by width (X axis)
	for x in range(GRID_WIDTH):
		grid.append([])  # each will become grid[x]

	# Create cells column by column
	for x in range(GRID_WIDTH):
		for y in range(GRID_HEIGHT):

			var cell = CellScene.instantiate()
			cell.cell_vector = Vector2i(x, y)
			cell.position = start_pos + Vector2(x, y) * (CELL_SIZE + CELL_SPACING)

			add_child(cell)
			grid[x].append(cell)
			all_cells.append(cell)

func get_empty_cells(cell_pool : Array[Cell] = all_cells):
	
	var cell_array = cell_pool
	var empty_cells : Array[Cell]
	for x in cell_array:
		if x.occupant == null:
			empty_cells.append(x)
			
	print ("returning empty cells from grid...", empty_cells)
	return empty_cells

func get_all_enemies() -> Array[Enemy]:
	var enemies : Array[Enemy]
	for x in all_cells:
		if x.occupant != null:
			if x.occupant is Enemy:
				enemies.append(x.occupant)
	
	print ("returning all enemies from grid...", enemies)
	return enemies
	
func get_adjacent_cells(cell: Cell, include_diagonal : bool = false) -> Array[Cell]:
	var adjacent_cells :Array[Cell] = []
	var cell_pos = cell.cell_vector

	var directions = [
		Vector2i(0, -1),	# Up
		Vector2i(0, 1),		# Down
		Vector2i(-1, 0),	# Left
		Vector2i(1, 0)		# Right
	]

	if include_diagonal:
		directions.append(Vector2i(-1, -1))
		directions.append(Vector2i(1, -1))
		directions.append(Vector2i(-1, 1))
		directions.append(Vector2i(1, 1))

	for d in directions:
		var p = cell_pos + d
		if is_in_bounds(p):
			adjacent_cells.append(grid[p.x][p.y])

	return adjacent_cells

func get_adjacent_units(cell: Cell):
	var cells = get_adjacent_cells(cell,true)
	var units : Array[Unit] = []
	for x in cells:
		if x.occupant != null:
			if x.occupant is Unit:
				units.append(x.occupant)
	
	return units
	
func get_cleave_targets(attacker_cell: Cell, target_cell: Cell) -> Array[Cell]:
	var cleave_cells : Array[Cell] = []

	var a = attacker_cell.cell_vector
	var t = target_cell.cell_vector

	var dx = t.x - a.x
	var dy = t.y - a.y

	# Normalize direction to -1, 0, or 1
	dx = sign(dx)
	dy = sign(dy)

	# If attacker and target are on the same cell (shouldn't happen)
	if dx == 0 and dy == 0:
		return cleave_cells

	# Perpendicular directions
	# (dx, dy) rotated 90° left and right
	var perp_1 = Vector2i(-dy, dx)
	var perp_2 = Vector2i(dy, -dx)

	var p1 = t + perp_1
	var p2 = t + perp_2

	if is_in_bounds(p1):
		cleave_cells.append(grid[p1.x][p1.y])

	if is_in_bounds(p2):
		cleave_cells.append(grid[p2.x][p2.y])

	return cleave_cells

func get_impale_target(attacker_cell: Cell, target_cell: Cell) -> Cell:
	var a = attacker_cell.cell_vector
	var t = target_cell.cell_vector

	var dx = t.x - a.x
	var dy = t.y - a.y

	# Normalize direction to -1, 0, or 1
	dx = sign(dx)
	dy = sign(dy)

	# Same-cell safety (shouldn't happen)
	if dx == 0 and dy == 0:
		return null

	# Cell directly behind the target (same direction again)
	var behind_pos = t + Vector2i(dx, dy)

	if not is_in_bounds(behind_pos):
		return null

	return grid[behind_pos.x][behind_pos.y]	

func get_row(cell: Cell) -> Array[Cell]:
	var y = cell.cell_vector.y
	var row_cells: Array[Cell] = []

	if y < 0 or y >= GRID_HEIGHT:
		return row_cells

	for x in range(GRID_WIDTH):
		row_cells.append(grid[x][y])

	return row_cells

func get_column(cell: Cell) -> Array[Cell]:
	var x = cell.cell_vector.x
	var col_cells: Array[Cell] = []

	if x < 0 or x >= GRID_WIDTH:
		return col_cells

	for y in range(GRID_HEIGHT):
		col_cells.append(grid[x][y])

	return col_cells

func get_cell_in_direction(cell: Cell, direction: Enums.Direction, include_diagonals: bool = true) -> Cell:

	var p = cell.cell_vector
	var t: Vector2i

	match direction:
		Enums.Direction.UP:
			t = p + Vector2i(0, -1)
		Enums.Direction.DOWN:
			t = p + Vector2i(0, 1)
		Enums.Direction.LEFT:
			t = p + Vector2i(-1, 0)
		Enums.Direction.RIGHT:
			t = p + Vector2i(1, 0)

		Enums.Direction.UP_LEFT:
			if not include_diagonals: return null
			t = p + Vector2i(-1, -1)
		Enums.Direction.UP_RIGHT:
			if not include_diagonals: return null
			t = p + Vector2i(1, -1)
		Enums.Direction.DOWN_LEFT:
			if not include_diagonals: return null
			t = p + Vector2i(-1, 1)
		Enums.Direction.DOWN_RIGHT:
			if not include_diagonals: return null
			t = p + Vector2i(1, 1)

		_:
			return null

	if not is_in_bounds(t):
		return null

	return grid[t.x][t.y]

func get_obstructing_unit(start_cell: Cell, direction: Enums.Direction) -> Unit:
	var dir := Vector2i.ZERO
	match direction:
		Enums.Direction.UP: dir = Vector2i(0, -1)
		Enums.Direction.DOWN: dir = Vector2i(0, 1)
		Enums.Direction.LEFT: dir = Vector2i(-1, 0)
		Enums.Direction.RIGHT: dir = Vector2i(1, 0)
		Enums.Direction.UP_LEFT: dir = Vector2i(-1, -1)
		Enums.Direction.UP_RIGHT: dir = Vector2i(1, -1)
		Enums.Direction.DOWN_LEFT: dir = Vector2i(-1, 1)
		Enums.Direction.DOWN_RIGHT: dir = Vector2i(1, 1)
		_: return null
	var p = start_cell.cell_vector + dir
	while is_in_bounds(p):
		var cell = grid[p.x][p.y]
		if cell.occupant != null:
			return cell.occupant
		p += dir
	return null

func get_cells_in_path(cell_1: Cell, cell_2: Cell) -> Array[Cell]:
	var path : Array[Cell] = []

	var a = cell_1.cell_vector
	var b = cell_2.cell_vector
	var p = a

	while p != b:
		var dx = b.x - p.x
		var dy = b.y - p.y
		var step = Vector2i(sign(dx), sign(dy))
		p += step
		if not is_in_bounds(p):
			return []
		path.append(grid[p.x][p.y])

	return path


func get_units_in_path(cell_1: Cell, cell_2: Cell) -> Array[Unit]:
	var units : Array[Unit] = []
	for x in get_cells_in_path(cell_1,cell_2):
		if x.occupant != null:
			units.append(x.occupant)
	return units

func has_clear_path(cell_1: Cell, cell_2: Cell) -> bool:
	var path = get_cells_in_path(cell_1, cell_2)
	if path.is_empty():
		return false

	for c in path:
		if c != cell_2 and not c.is_empty():
			return false

	return true
	
func get_furthest_empty_cell_in_direction(cell_1: Cell, cell_2: Cell) -> Cell:
	var a = cell_1.cell_vector
	var b = cell_2.cell_vector
	var dx = b.x - a.x
	var dy = b.y - a.y
	if not (dx == 0 or dy == 0 or abs(dx) == abs(dy)):
		return null
	var step = Vector2i(sign(dx), sign(dy))
	var p = a + step
	var last_empty : Cell = null
	while Global.grid.is_in_bounds(p):
		var c = Global.grid.grid[p.x][p.y]
		if not c.is_empty():
			break
		last_empty = c
		p += step
	return last_empty

func get_distance(cell_1 : Cell, cell_2 : Cell) -> int: 
	return max(abs(cell_1.cell_vector.x - cell_2.cell_vector.x), 
	abs(cell_1.cell_vector.y - cell_2.cell_vector.y))

func is_in_range(cell_1 : Cell, cell_2 : Cell, range : int) -> bool:
		pass
		return false

func is_in_bounds(pos: Vector2i) -> bool:
	return (
		pos.x >= 0 and pos.x < GRID_WIDTH and
		pos.y >= 0 and pos.y < GRID_HEIGHT
	)
