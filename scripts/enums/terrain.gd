class_name Terrain


enum Type {
	NONE,
	GRASS,
	FOREST,
	WATER,
	MOUNTAIN,
}


static func get_type_from_name(name: String) -> Type:
	match name.to_upper():
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