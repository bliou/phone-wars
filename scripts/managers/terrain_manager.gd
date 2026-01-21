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

			print("terrain cell %s add at %s" %[terrain_type, cell])

 
func get_terrain_type(cell: Vector2i) -> TerrainType.Values:
	return terrain_cells.get(cell, TerrainType.Values.NONE)



func get_terrain_data(cell: Vector2i) -> TerrainData:
	var terrain_type: int = terrain_cells[cell]
	
	for terrain_data in terrain_database.terrains:
		if terrain_data.terrain_type == terrain_type:
			return terrain_data

	return null
