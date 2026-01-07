class_name Terrain
extends Resource

enum Type {
	NONE,
	ROAD,
	GRASS,
	FOREST,
	WATER,
	MOUNTAIN,
}

static func get_name_from_type(type: Type) -> String:
	match type:
		Type.ROAD:
			return "ROAD" 
		Type.GRASS:
			return "GRASS"
		Type.FOREST:
			return "FOREST"
		Type.WATER:
			return "WATER"
		Type.MOUNTAIN:
			return "MOUNTAIN"
	
	push_error("Unknown terrain type: %d" % type)
	return "NONE"  # default fallback


static func get_type_from_name(name: String) -> Type:
	match name.to_upper():
		"ROAD":
			return Type.ROAD
		"GRASS":
			return Type.GRASS
		"FOREST":
			return Type.FOREST
		"WATER":
			return Type.WATER
		"MOUNTAIN":
			return Type.MOUNTAIN
	
	push_error("Unknown terrain type name: %s" % name)
	return Type.NONE  # default fallback