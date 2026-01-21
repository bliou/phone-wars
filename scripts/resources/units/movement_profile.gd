class_name MovementProfile
extends Resource

@export var road_cost: float = 1.0
@export var grass_cost: float = 1.0
@export var forest_cost: float = 1.5
@export var water_cost: float = INF
@export var mountain_cost: float = INF


func get_cost(terrain_type: TerrainType.Values) -> float:
	match terrain_type:
		TerrainType.Values.ROAD:
			return road_cost
		TerrainType.Values.GRASS:
			return grass_cost
		TerrainType.Values.FOREST:
			return forest_cost
		TerrainType.Values.SEA:
			return water_cost
		TerrainType.Values.HILL:
			return mountain_cost
		_:
			return INF