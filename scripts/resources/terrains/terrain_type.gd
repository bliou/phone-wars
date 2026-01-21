class_name TerrainType

enum Values {
	NONE,
	SEA,
	GRASS,
	FOREST,
	ROAD,
	HILL,
}

static func get_name_from_type(val: Values) -> String:
	match val:
		Values.SEA:
			return "Sea" 
		Values.GRASS:
			return "Grass"
		Values.FOREST:
			return "Forest"
		Values.ROAD:
			return "Road"
		Values.HILL:
			return "Hill"
	
	push_error("Unknown terrain type: %d" % val)
	return "NONE"  # default fallback