class_name Grid
extends Node2D


signal cell_clicked(cell_position: Vector2i, terrain: Variant, occupant: Variant)

@export var inputManager: InputManager

@export var terrain_node: Node2D
@export var units_node: Node2D

var terrain_layers: Array[TileMapLayer] = []
var terrain_cells := {}  # Vector2i → terrain type
var occupied_cells := {}  # Vector2i → unit/building

var cell_size: Vector2 = Vector2(16, 16)  # default cell size

var astar: AStarGrid2D = AStarGrid2D.new()

func _ready() -> void:
	if not terrain_node:
		return

	for child in terrain_node.get_children():
		if child is TileMapLayer:
			terrain_layers.append(child as TileMapLayer)

	init_astar()
	init_terrain_cells()
	init_occupied_cells()

	# subscribe to input events
	inputManager.click_detected.connect(on_click_detected)
	

func init_astar() -> void:
	astar.clear()
	var grid_size = Vector2i(100, 100)  # Example grid size, adjust as needed
	astar.region = Rect2i(Vector2i.ZERO, grid_size)
	astar.cell_size = cell_size
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.update()


func init_terrain_cells() -> void:
	terrain_cells.clear()
	for layer in terrain_layers:
		for cell in layer.get_used_cells():
			terrain_cells[cell] = layer.name
			# TODO: Add terrain-specific weight scaling using terrain data
			if layer.name == "Forest":
				astar.set_point_weight_scale(cell, 2.0)  # Example: forests are harder to traverse
			else:
				astar.set_point_weight_scale(cell, 1.0)  # Adjust weight scale based on terrain type if needed


func init_occupied_cells() -> void:
	occupied_cells.clear()
	for unit in units_node.get_children():
		if unit is Unit:
			var cell_pos: Vector2i = Vector2i(unit.position / cell_size)
			occupied_cells[cell_pos] = unit
			astar.set_point_solid(cell_pos, true)


func on_click_detected(world_pos: Vector2) -> void:
	var cell_pos: Vector2i = world_pos / cell_size
	cell_clicked.emit(cell_pos, terrain_cells.get(cell_pos, null), occupied_cells.get(cell_pos, null))


func get_world_position_from_cell(cell_position: Vector2i) -> Vector2:
	return Vector2(cell_position) * cell_size + cell_size / 2


func set_occupied_cell(cell_position: Vector2i, occupant: Variant) -> void:
	if occupant == null:
		occupied_cells.erase(cell_position)
		astar.set_point_solid(cell_position, false)
	else:
		occupied_cells[cell_position] = occupant
		astar.set_point_solid(cell_position, true)


func is_cell_blocked(cell_position: Vector2i) -> bool:
	return occupied_cells.has (cell_position)


func get_grid_path(start_cell: Vector2i, end_cell: Vector2i) -> Array[Vector2i]:
	if is_cell_blocked(end_cell):
		return []

	return astar.get_id_path(start_cell, end_cell)


func get_world_path(start_cell: Vector2i, end_cell: Vector2i) -> Array[Vector2]:
	var cell_path = get_grid_path(start_cell, end_cell)
	var world_path: Array[Vector2] = []
	for cell in cell_path:
		world_path.append(get_world_position_from_cell(cell))
	return world_path
