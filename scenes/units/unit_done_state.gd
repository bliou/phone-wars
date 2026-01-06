class_name UnitDoneState
extends State

var unit: Unit

func _init(state_name: String, p_unit: Unit) -> void:
	super._init(state_name)
	unit = p_unit


func _enter(_params: Dictionary = {}) -> void:
	unit.animated_sprite.play("idle")
	unit.animated_sprite.flip_h = unit.team.team_face_direction == Team.FaceDirection.LEFT
	unit.animated_sprite.modulate = Color(0.6, 0.6, 0.6)
	unit.exhausted = true


func _exit() -> void:
	unit.animated_sprite.stop()
	unit.animated_sprite.modulate = Color(1.0, 1.0, 1.0)
	unit.exhausted = false


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass
