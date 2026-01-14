class_name Building
extends Area2D

signal captured_by(unit: Unit)

@export var construction_profile: ConstructionProfile
@export var capture_point: int = 20

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var grid_pos: Vector2i = Vector2i.ZERO
var team: Team
var actual_capture_point: int

var fsm: StateMachine
var idle_state: BuildingIdleState
var selected_state: BuildingSelectedState
var done_state: BuildingDoneState


func _ready() -> void:
	# Make the material unique to this instance
	animated_sprite.material = animated_sprite.material.duplicate()
	

func setup(p_team: Team) -> void:
	set_team(p_team)
	actual_capture_point = capture_point

	idle_state = BuildingIdleState.new("building_idle", self)
	selected_state = BuildingSelectedState.new("building_selected", self)
	done_state = BuildingDoneState.new("building_done", self)

	fsm = StateMachine.new(name, idle_state)


func set_team(p_team: Team) -> void:
	team = p_team
	animated_sprite.material.set_shader_parameter("replace_color", p_team.team_color)


func try_to_capture_by(unit: Unit) -> void:
	if unit.team == team:
		return

	actual_capture_point -= unit.capture_capacity()
	print("capture_capacity %s / actual_capture_point %s" %[unit.capture_capacity(), actual_capture_point])
	if actual_capture_point > 0:
		return

	captured(unit)


func captured(unit: Unit) -> void:
	reset_capture_points()
	team.buildings_manager.remove_building(self)
	set_team(unit.team)
	team.buildings_manager.add_building(self)

	captured_by.emit(unit)


func reset_capture_points() -> void:
	actual_capture_point = capture_point
