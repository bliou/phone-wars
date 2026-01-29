class_name Explosion
extends Node2D

signal finished


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D 


func _ready() -> void:
	animated_sprite.play("explode")
	animated_sprite.animation_finished.connect(_on_animation_finished)


func _on_animation_finished() -> void:
	finished.emit()
	queue_free()