class_name Team
extends Node

enum Type {
	PLAYABLE,
	AI,
	NEUTRAL,
}

enum FaceDirection {
	RIGHT,
	LEFT,
}

@export var team_id: int = 1
@export var team_color: Color = Color.BLACK
@export var team_type: Type = Type.NEUTRAL
@export var team_face_direction: FaceDirection = FaceDirection.RIGHT
@export var grid: Grid

@onready var units_manager: UnitsManager = $UnitsManager
@onready var buildings_manager: BuildingsManager = $BuildingsManager


func _ready() -> void:
	if team_type != Type.NEUTRAL: 
		units_manager.setup(grid, self)
	
	buildings_manager.setup(grid, self)

func start_turn() -> void:
	pass


func end_turn() -> void:
	if team_type != Type.NEUTRAL: 
		units_manager.reset_units()


func is_playable() -> bool:
	return team_type == Type.PLAYABLE


func neutral_team() -> bool:
	return team_type == Type.NEUTRAL
