class_name Team
extends Node

enum Type {
	PLAYABLE,
	AI,
	NEUTRAL,
}

@export var team_id: int = 1
@export var team_profile: TeamProfile
@export var team_type: Type = Type.NEUTRAL
@export var face_direction: FaceDirection.Values = FaceDirection.Values.LEFT

@onready var units_manager: UnitsManager = $UnitsManager
@onready var buildings_manager: BuildingsManager = $BuildingsManager

func setup(grid: Grid, query_manager: QueryManager) -> void:
	units_manager.setup(grid, query_manager, self)
	buildings_manager.setup(grid, query_manager, self)
	

func start_turn() -> void:
	pass


func end_turn() -> void:
	units_manager.reset_units()


func is_playable() -> bool:
	return team_type == Type.PLAYABLE


func neutral_team() -> bool:
	return team_type == Type.NEUTRAL


func is_same_team(team: Team) -> bool:
	return self == team


# Team profile getters
func replace_colors(material: Material) -> void:
	material.set_shader_parameter("original_colors", team_profile.original_colors)
	material.set_shader_parameter("replace_colors", team_profile.replace_colors)
	