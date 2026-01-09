class_name UnitType
extends Node


enum Values {
	INFANTRY,
	VEHICLE
}


static func is_light_type(val: Values) -> bool:
	return val == Values.INFANTRY