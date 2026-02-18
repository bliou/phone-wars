class_name Building
extends Area2D

signal captured_by(unit: Unit)

@export var building_profile: BuildingProfile
@export var production_list: ProductionList

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var grid_pos: Vector2i = Vector2i.ZERO
var team: Team

var fsm: StateMachine
var idle_state: BuildingIdleState
var selected_state: BuildingSelectedState
var done_state: BuildingDoneState


func _ready() -> void:
	# Make the material unique to this instance
	animated_sprite.material = animated_sprite.material.duplicate()
	z_index = Ordering.BUILDINGS
	

func setup(p_team: Team) -> void:
	set_team(p_team)

	idle_state = BuildingIdleState.new("building_idle", self)
	selected_state = BuildingSelectedState.new("building_selected", self)
	done_state = BuildingDoneState.new("building_done", self)

	fsm = StateMachine.new(name, idle_state)


func set_team(p_team: Team) -> void:
	team = p_team
	animated_sprite.material.set_shader_parameter("original_colors", team.team_profile.original_colors)
	animated_sprite.material.set_shader_parameter("replace_colors", team.team_profile.replace_colors)


func captured(new_team: Team) -> void:
	team.buildings_manager.remove_building(self)
	set_team(new_team)
	new_team.buildings_manager.add_building(self)

	captured_by.emit(new_team)


# Unit profile getters
func defense() -> int:
	return building_profile.building_defense


func icon() -> Texture2D:
	return building_profile.building_icon


func type() -> BuildingType.Values:
	return building_profile.type


func max_capture_points() -> int:
	return building_profile.capture_points


func can_be_selected() -> bool:
	return production_list != null