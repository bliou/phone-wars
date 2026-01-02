class_name InputManager
extends Node2D

signal click_detected(world_pos: Vector2)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var world_pos = get_viewport().get_canvas_transform().affine_inverse() * event.position
		emit_signal("click_detected", world_pos)

	elif event is InputEventScreenTouch and event.pressed:
		var world_pos = get_viewport().get_canvas_transform().affine_inverse() * event.position
		emit_signal("click_detected", world_pos)
