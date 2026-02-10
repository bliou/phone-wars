class_name BuildingType

enum Values {
	BASE,
	CITY,
	HQ,
}


static func get_name_from_type(val: Values) -> String:
	match val:
		Values.BASE:
			return "Base" 
		Values.CITY:
			return "City"
		Values.HQ:
			return "HQ"
	
	push_error("Unknown building type: %d" % val)
	return "NONE"  # default fallback

