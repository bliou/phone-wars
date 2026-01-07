class_name Unit
extends Area2D

signal unit_moved()

@export var speed: float = 100.0
@export var unit_profile: UnitProfile = null
@export var size: Vector2i = Vector2i(32, 32)

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var movement_indicator: MovementIndicatorComponent = $MovementIndicatorComponent

var grid_pos: Vector2i = Vector2i.ZERO
var reachable_cells: Dictionary = {}  # Vector2i → cost
var exhausted: bool = false

var team: Team

var fsm: StateMachine
var idle_state: UnitIdleState
var moving_state: UnitMovingState
var selected_state: UnitSelectedState
var done_state: UnitDoneState


func _ready() -> void:
	# Make the material unique to this instance
	animated_sprite.material = animated_sprite.material.duplicate()
	z_index = 2 # To make sure the unit is always visible


func _process(delta: float) -> void:
	fsm._process(delta)


func _physics_process(delta: float) -> void:
	fsm._physics_process(delta)


func setup(p_team: Team) -> void:
	set_team(p_team)
	
	idle_state = UnitIdleState.new("unit_idle", self)
	moving_state = UnitMovingState.new("unit_moving", self)
	selected_state = UnitSelectedState.new("unit_selected", self)
	done_state = UnitDoneState.new("unit_done", self)

	fsm = StateMachine.new(name, idle_state)


func set_team(p_team: Team) -> void:
	team = p_team
	animated_sprite.material.set_shader_parameter("replace_color", p_team.team_color)


func select() -> void:
	fsm.change_state(selected_state)


func deselect() -> void:
	fsm.change_state(idle_state)


func exhaust() -> void:
	fsm.change_state(done_state)


func ready_to_move() -> void:
	fsm.change_state(idle_state)
	

func move_following_path(p: Array[Vector2]) -> void:
	if p.is_empty():
		return

	print("Unit moving along path: %s" % str(p))

	fsm.change_state(moving_state, {"path": p})


func get_terrain_cost(terrain: Terrain.Type) -> float:
	return unit_profile.movement_profile.get_cost(terrain)


func can_capture_building(building: Building) -> bool:
	if building.grid_pos != grid_pos:
		return false

	if building.team == team:
		return false

	return unit_profile.capture_capacity > 0