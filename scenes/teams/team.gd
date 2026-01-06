class_name Team
extends Node

enum FaceDirection {
	RIGHT,
	LEFT,
}

@export var team_id: int = 1
@export var team_color: Color = Color.BLACK
@export var team_face_direction: FaceDirection = FaceDirection.RIGHT
@export var grid: Grid

@onready var units_manager: UnitsManager = $UnitsManager


func _ready() -> void:
	units_manager.setup(grid, self)

func start_turn() -> void:
	pass


func end_turn() -> void:
	units_manager.reset_units()


# TODO: use an export variable for that
func is_playable() -> bool:
	return true
