class_name Unit
extends Node2D

signal unit_selected()
signal unit_deselected()
signal unit_previewed(p_path: Array[Vector2])

@export var speed: float = 100.0
@export var movement_points: int = 3
@export var movement_profile: MovementProfile
@export var size: Vector2i = Vector2i(16, 16)
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var grid_pos: Vector2i = Vector2i.ZERO
var reachable_cells: Dictionary = {}  # Vector2i → cost

var fsm: StateMachine
var idle_state: IdleState
var moving_state: MovingState
var selected_state: SelectedState
var preview_state: PreviewState


func _ready() -> void:
	idle_state = IdleState.new("idle", self)
	moving_state = MovingState.new("moving", self)
	selected_state = SelectedState.new("selected", self)
	preview_state = PreviewState.new("preview", self)

	fsm = StateMachine.new(idle_state)


func _process(delta: float) -> void:
	fsm._process(delta)


func _physics_process(delta: float) -> void:
	fsm._physics_process(delta)


func select() -> void:
	fsm.change_state(selected_state)


func deselect() -> void:
	fsm.change_state(idle_state)


func move_intent_to(intent: MovementIntent) -> void:
	if intent.path.is_empty():
		return

	print("Unit moving with intent to: %s" % str(intent.final_cell))

	fsm.change_state(preview_state, {"movement_intent": intent})


func execute_intent(intent: MovementIntent) -> void:
	if intent.path.is_empty():
		return

	print("Unit moving along path: %s" % str(intent.path))
	grid_pos = intent.final_cell

	fsm.change_state(moving_state, {"path": intent.path})
