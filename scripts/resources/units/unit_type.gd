class_name UnitType

enum Values {
	INFANTRY,
	RECON,
	LIGHT_TANK,
	ARTILLERY,
}


static func get_name_from_type(val: Values) -> String:
	match val:
		Values.INFANTRY:
			return "Infantry" 
		Values.RECON:
			return "Recon"
		Values.LIGHT_TANK:
			return "Light tank"
		Values.ARTILLERY:
			return "Artillery"
	
	push_error("Unknown terrain type: %d" % val)
	return "NONE"  # default fallback


static func is_light_type(val: Values) -> bool:
	return val == Values.INFANTRY