class_name Unit
extends Node2D

@export var speed: float = 100.0
@export var movement_points: int = 3
@export var movement_profile: MovementProfile
@export var size: Vector2i = Vector2i(16, 16)
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var movement_indicator: MovementIndicatorComponent = $MovementIndicatorComponent

var grid_pos: Vector2i = Vector2i.ZERO
var reachable_cells: Dictionary = {}  # Vector2i → cost

var fsm: StateMachine
var idle_state: IdleState
var moving_state: MovingState
var selected_state: SelectedState

func _ready() -> void:
	idle_state = IdleState.new("idle", self)
	moving_state = MovingState.new("moving", self)
	selected_state = SelectedState.new("selected", self)

	fsm = StateMachine.new(name, idle_state)


func _process(delta: float) -> void:
	fsm._process(delta)


func _physics_process(delta: float) -> void:
	fsm._physics_process(delta)


func select() -> void:
	fsm.change_state(selected_state)


func deselect() -> void:
	fsm.change_state(idle_state)


func move_following_path(p: Array[Vector2]) -> void:
	if p.is_empty():
		return

	print("Unit moving along path: %s" % str(p))

	fsm.change_state(moving_state, {"path": p})
