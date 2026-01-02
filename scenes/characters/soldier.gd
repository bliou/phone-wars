class_name Soldier
extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 100.0

var is_selected: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func select() -> void:
	is_selected = true
	animated_sprite.modulate = Color(1, 1, 0)  # Change color to yellow when selected


func deselect() -> void:
	is_selected = false
	animated_sprite.modulate = Color(1, 1, 1)  # Change color back to white when deselected


func move_to_position(target_position: Vector2) -> void:
	var direction: Vector2 = (target_position - global_position).normalized()
	global_position += direction * speed * get_process_delta_time()
	animated_sprite.play("walk")
