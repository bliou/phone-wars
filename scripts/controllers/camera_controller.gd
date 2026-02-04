
class_name CameraController
extends Node2D


@onready var camera: Camera2D = $Camera2D


var pan_enabled: bool = false


func setup(ui_controller: UIController, input_manager: InputManager) -> void:
	ui_controller.camera_pan_enabled.connect(on_camera_pan_enabled)
	input_manager.pan_requested.connect(on_pan_requested)


func on_camera_pan_enabled(enabled: bool) -> void:
	pan_enabled = enabled


func on_pan_requested(delta: Vector2) -> void:
	if not pan_enabled:
		return

	move_by(delta)

	
func move_by(delta: Vector2) -> void:
	camera.position -= delta

