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

func get_cell_in_direction(cell: Cell, direction: Enums.Direction) -> Cell:

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
		_:
			return null

	if not is_in_bounds(t):
		return null

	return grid[t.x][t.y]

func is_in_bounds(pos: Vector2i) -> bool:
	return (
		pos.x >= 0 and pos.x < GRID_WIDTH and
		pos.y >= 0 and pos.y < GRID_HEIGHT
	)
