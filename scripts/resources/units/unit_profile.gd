class_name UnitProfile
extends Resource


@export var icon: Texture2D = null

@export var type: UnitType.Values = UnitType.Values.INFANTRY
@export var movement_points: int = 3
@export var movement_profile: MovementProfile
@export var capture_capacity: int = 10
@export var health: int = 10

@export var attack_profile: AttackProfile
@export var defense_profile: DefenseProfile