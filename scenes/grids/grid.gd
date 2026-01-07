class_name Grid
extends Node2D


signal cell_clicked(cell_position: Vector2i)

@export var inputManager: InputManager

@export var terrain_node: Node2D

var terrain_layers: Array[TileMapLayer] = []
var terrain_cells := {}  # Vector2i → terrain type
var building_cells := {}  # Vector2i → building

var cell_size: Vector2 = Vector2(32, 32)  # default cell size

func _ready() -> void:
	if not terrain_node:
		return

	for child in terrain_node.get_children():
		if child is TileMapLayer:
			terrain_layers.append(child as TileMapLayer)

	init_terrain_cells()

	# subscribe to input events
	inputManager.click_detected.connect(on_click_detected)


func init_terrain_cells() -> void:
	terrain_cells.clear()
	for layer in terrain_layers:
		for cell in layer.get_used_cells():
			terrain_cells[cell] = Terrain.get_type_from_name(layer.name)


func on_click_detected(world_pos: Vector2) -> void:
	var cell_pos: Vector2i = world_pos / cell_size
	cell_clicked.emit(cell_pos)


func get_world_position_from_cell(cell_position: Vector2i) -> Vector2:
	return Vector2(cell_position) * cell_size + cell_size / 2


func get_reachable_cells(start: Vector2i, unit: Unit) -> Dictionary:
	var frontier := [{ "cell": start, "cost": 0.0 }]
	var visited := { start: 0.0 }

	while frontier.size() > 0:
		frontier.sort_custom(func(a, b): return a.cost < b.cost)
		var current = frontier.pop_front()
		var cell: Vector2i = current.cell
		var cost: float = current.cost

		for neighbor in get_neighbors(cell):
			var terrain: Terrain.Type = terrain_cells.get(neighbor, Terrain.Type.NONE)
			var step_cost = unit.movement_profile.get_cost(terrain)
			if step_cost == INF:
				continue

			var new_cost = cost + step_cost
			if new_cost > unit.movement_points:
				continue

			if not visited.has(neighbor) or new_cost < visited[neighbor]:
				visited[neighbor] = new_cost
				frontier.append({ "cell": neighbor, "cost": new_cost })

	return visited  # cell → cost


# Helpers method to get all the neighbors of a cell even if disabled in AStar
func get_neighbors(cell: Vector2i) -> Array[Vector2i]:
	const DIRS : Array[Vector2i] = [
		Vector2i.LEFT,
		Vector2i.RIGHT,
		Vector2i.UP,
		Vector2i.DOWN
	]
	var neighbors: Array[Vector2i] = []

	for d in DIRS:
		neighbors.append(cell + d)

	return neighbors
