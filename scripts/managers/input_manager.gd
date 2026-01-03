class_name InputManager
extends Node2D


signal click_detected(world_pos: Vector2)
signal end_turn()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var world_pos = get_viewport().get_canvas_transform().affine_inverse() * event.position
		click_detected.emit(world_pos)

	elif event is InputEventScreenTouch and event.pressed:
		var world_pos = get_viewport().get_canvas_transform().affine_inverse() * event.position
		click_detected.emit(world_pos)

	# Temporary
	if event.is_action_pressed("end_turn"):
		end_turn.emit()