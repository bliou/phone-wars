class_name InputManager
extends Node

signal short_tap(world_pos: Vector2)
signal long_press(world_pos: Vector2)
signal long_press_release(world_pos: Vector2)

# Config
@export var long_press_time := 0.5 # seconds

# State
var press_time := 0.0
var pressed := false
var long_pressed := false
var pressed_position := Vector2.ZERO


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			on_touch_pressed(event.position)
		else:
			on_touch_released(event.position)
	elif event is InputEventMouseButton:
		if event.pressed:
			on_touch_pressed(event.position)
		else:
			on_touch_released(event.position)


func _process(delta: float) -> void:
	if pressed and not long_pressed:
		press_time += delta
		if press_time >= long_press_time:
			long_press.emit(pressed_position)
			long_pressed = true


# Called immediately on touch down
func on_touch_pressed(pos: Vector2) -> void:
	press_time = 0.0
	pressed = true
	long_pressed = false
	pressed_position = pos


# Called when finger/mouse released
func on_touch_released(pos: Vector2) -> void:
	if long_pressed:
		long_press_release.emit(pos)
	else:
		short_tap.emit(pos)
	pressed = false
	press_time = 0.0
	long_pressed = false

