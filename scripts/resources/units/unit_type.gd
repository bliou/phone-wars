class_name UnitType
extends Node


enum Values {
	INFANTRY,
	RECON
}


static func get_name_from_type(val: Values) -> String:
	match val:
		Values.INFANTRY:
			return "Infantry" 
		Values.RECON:
			return "Recon"
	
	push_error("Unknown terrain type: %d" % val)
	return "NONE"  # default fallback

static func is_light_type(val: Values) -> bool:
	return val == Values.INFANTRY