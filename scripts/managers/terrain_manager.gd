class_name TerrainManager
extends Node

@export var terrain_database: TerrainDatabase

var terrain_layers: Array[TileMapLayer] = []
var terrain_cells := {}  # Vector2i → terrain type


func _ready() -> void:
	for child in get_children():
		if child is TileMapLayer:
			terrain_layers.append(child as TileMapLayer)

	init_terrain_cells()
	

func init_terrain_cells() -> void:
	terrain_cells.clear()
	for layer in terrain_layers:
		for cell in layer.get_used_cells():
			var tile_data: TileData = layer.get_cell_tile_data(cell)
			var terrain_type: TerrainType.Values = tile_data.get_custom_data("terrain_type")
			terrain_cells[cell] = terrain_type

 
func get_terrain_type(cell: Vector2i) -> TerrainType.Values:
	return terrain_cells.get(cell, TerrainType.Values.NONE)



func get_terrain_data(cell: Vector2i) -> TerrainData:
	var terrain_type: int = terrain_cells[cell]
	
	for terrain_data in terrain_database.terrains:
		if terrain_data.terrain_type == terrain_type:
			return terrain_data

	return null


func world_to_cell(world_pos: Vector2) -> Vector2i:
	return terrain_layers[0].local_to_map(terrain_layers[0].to_local(world_pos))


func cell_to_world(cell: Vector2i) -> Vector2:
	return terrain_layers[0].to_global(terrain_layers[0].map_to_local(cell))


func cell_to_world_center(cell: Vector2i) -> Vector2:
	var local: Vector2 = terrain_layers[0].map_to_local(cell)
	var half: Vector2 = terrain_layers[0].tile_set.tile_size * 0.5
	return terrain_layers[0].to_global(local + half)