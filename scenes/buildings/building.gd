class_name Building
extends Area2D


@export var construction_profile: ConstructionProfile


var grid_pos: Vector2i = Vector2i.ZERO
var team: Team

var fsm: StateMachine
var idle_state: BuildingIdleState
var selected_state: BuildingSelectedState
var done_state: BuildingDoneState


func setup(p_team: Team) -> void:
	team = p_team
	
	idle_state = BuildingIdleState.new("building_idle", self)
	selected_state = BuildingSelectedState.new("building_selected", self)
	done_state = BuildingDoneState.new("building_done", self)

	fsm = StateMachine.new(name, idle_state)



