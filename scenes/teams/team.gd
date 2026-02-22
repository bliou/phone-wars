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
@export var funds: int = 1500

@onready var units_manager: UnitsManager = $UnitsManager
@onready var buildings_manager: BuildingsManager = $BuildingsManager


func setup(grid: Grid, query_manager: QueryManager) -> void:
	units_manager.setup(grid, query_manager, self)
	buildings_manager.setup(grid, query_manager, self)
	

func earn_money(income: int) -> void:
	funds += income


func end_turn() -> void:
	units_manager.reset_units()


func is_playable() -> bool:
	return team_type == Type.PLAYABLE


func neutral_team() -> bool:
	return team_type == Type.NEUTRAL


func is_same_team(team: Team) -> bool:
	return self == team


func can_buy(entry: ProductionEntry) -> bool:
	return entry.cost <= funds


func buy_unit(entry: ProductionEntry, cell_pos: Vector2i) -> void:
	funds -= entry.cost
	units_manager.add_unit(entry, cell_pos, self)
	

func get_hq_count() -> int:
	var count: int = 0
	for building: Building in buildings_manager.buildings.values():
		if building.type() == BuildingType.Values.HQ:
			count +=1

	return count


# Team profile getters
func replace_colors(material: Material) -> void:
	material.set_shader_parameter("original_colors", team_profile.original_colors)
	material.set_shader_parameter("replace_colors", team_profile.replace_colors)
	

func team_name() -> String:
	return team_profile.team_name


func get_focus_point() -> Vector2:
	for building: Building in buildings_manager.buildings.values():
		if building.type() == BuildingType.Values.HQ:
			return building.position

	return Vector2.ZERO
