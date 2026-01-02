class_name Unit
extends Node2D

@export var speed: float = 100.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_selected: bool = false

var idle_state: IdleState
var moving_state: MovingState

var fsm: StateMachine

func _ready() -> void:
	idle_state = IdleState.new("idle", self)
	moving_state = MovingState.new("moving", self)

	fsm = StateMachine.new(idle_state)


func _process(delta: float) -> void:
	fsm._process(delta)

func _physics_process(delta: float) -> void:
	fsm._physics_process(delta)

func select() -> void:
	is_selected = true
	animated_sprite.modulate = Color(1, 1, 0)  # Change color to yellow when selected


func deselect() -> void:
	is_selected = false
	animated_sprite.modulate = Color(1, 1, 1)  # Change color back to white when deselected


func move_following_path(p: Array[Vector2]) -> void:
	if p.is_empty():
		return

	print("Unit moving along path: %s" % str(p))

	fsm.change_state(moving_state, {"path": p})