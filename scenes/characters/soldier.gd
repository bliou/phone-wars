class_name Soldier
extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 100.0

var is_selected: bool = false
var target_position: Vector2 = Vector2.ZERO
var should_move: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_position = global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if not should_move:
		return
		
	var direction: Vector2 = (target_position - global_position).normalized()
	global_position += direction * speed * delta
	animated_sprite.play("walk_right")

	if should_move and global_position.distance_to(target_position) < 5.0:
		should_move = false
		animated_sprite.play("idle")


func select() -> void:
	is_selected = true
	animated_sprite.modulate = Color(1, 1, 0)  # Change color to yellow when selected


func deselect() -> void:
	is_selected = false
	animated_sprite.modulate = Color(1, 1, 1)  # Change color back to white when deselected


func move_to_position(tp: Vector2) -> void:
	print("Moving to position: ", tp)
	target_position = tp
	should_move = true
