class_name UnitDoneState
extends State

var unit: Unit

func _init(state_name: String, p_unit: Unit) -> void:
	super._init(state_name)
	unit = p_unit


func _enter(_params: Dictionary = {}) -> void:
	unit.exhausted = true
	unit.facing = unit.team.face_direction
	unit.reset_movement_points()
	print("entering done state")
	unit.idling()
	unit.animated_sprite.material.set_shader_parameter("disabled", 0.5)


func _exit() -> void:
	unit.animated_sprite.stop()
	unit.animated_sprite.material.set_shader_parameter("disabled", 0.0)
	unit.exhausted = false


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass
