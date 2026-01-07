class_name UnitProfile
extends Resource


enum UnitType {
	SOLDIER,
	RECON,
}

@export var movement_points: int = 3
@export var movement_profile: MovementProfile
@export var capture_capacity: int = 10