class_name Soldier
extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 100.0

var is_selected: bool = false
var path: Array[Vector2] = []
var currentPathIndex: int = 0
var moving: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if not moving:
		return

	if currentPathIndex >= path.size():
		stop_moving()
		return

	var target_position = path[currentPathIndex]
	var direction: Vector2 = (target_position - global_position).normalized()
	global_position += direction * speed * delta
	animated_sprite.play("walk_right")

	if global_position.distance_to(target_position) < 1.0:
		currentPathIndex += 1


func select() -> void:
	is_selected = true
	animated_sprite.modulate = Color(1, 1, 0)  # Change color to yellow when selected


func deselect() -> void:
	is_selected = false
	animated_sprite.modulate = Color(1, 1, 1)  # Change color back to white when deselected


func move_following_path(p: Array[Vector2]) -> void:
	print("Moving following path: ", p)
	if p.is_empty():
		return

	path = p
	currentPathIndex = 0
	moving = true


func stop_moving() -> void:
	moving = false
	animated_sprite.play("idle")
	path.clear()