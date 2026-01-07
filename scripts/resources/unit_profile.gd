class_name UnitProfile
extends Resource


enum UnitType {
	SOLDIER,
	RECON,
}

@export var type: UnitType = UnitType.SOLDIER
@export var movement_points: int = 3
@export var movement_profile: MovementProfile
@export var capture_capacity: int = 10
@export var health: int = 10