class_name MovementProfile
extends Resource

@export var road_cost: float = 1.0
@export var grass_cost: float = 1.0
@export var forest_cost: float = 1.5
@export var water_cost: float = INF
@export var mountain_cost: float = INF


func get_cost(terrain_type: Terrain.Type) -> float:
	match terrain_type:
		Terrain.Type.ROAD:
			return road_cost
		Terrain.Type.GRASS:
			return grass_cost
		Terrain.Type.FOREST:
			return forest_cost
		Terrain.Type.WATER:
			return water_cost
		Terrain.Type.MOUNTAIN:
			return mountain_cost
		_:
			return INF