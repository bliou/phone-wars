class_name Grid
extends Node2D

signal cell_clicked(cell_position: Vector2i, cell: Variant)

@export var terrain_node: Node2D

var terrain_layers: Array[TileMapLayer] = []
var terrain_cells := {}  # Vector2i → terrain type
var occupied_cells := {}  # Vector2i → unit/building

var cell_size: Vector2 = Vector2(16, 16)  # default cell size

func _ready() -> void:
	if not terrain_node:
		return

	for child in terrain_node.get_children():
		if child is TileMapLayer:
			terrain_layers.append(child as TileMapLayer)
			
	terrain_layers.sort_custom(func(a, b):
		return a.z_index < b.z_index
	)

	init_terrain_cells()

	# subscribe to input events
	var input_manager: InputManager = get_parent().get_node("InputManager") as InputManager
	input_manager.connect("click_detected", on_click_detected)


func init_terrain_cells() -> void:
	terrain_cells.clear()
	for layer in terrain_layers:
		for cell in layer.get_used_cells():
			terrain_cells[cell] = layer.name
			print("Terrain cell:", cell, "Type:", layer.name)


func on_click_detected(world_pos: Vector2) -> void:
	var cell_pos: Vector2i = world_pos / cell_size
	if cell_pos in terrain_cells:
		var cell = terrain_cells[cell_pos]
		emit_signal("cell_clicked", cell_pos, cell)

