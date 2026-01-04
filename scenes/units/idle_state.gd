class_name IdleState
extends State

var unit: Unit

func _init(state_name: String, p_unit: Unit) -> void:
	super._init(state_name)
	unit = p_unit


func _enter(_params: Dictionary = {}) -> void:
	unit.animated_sprite.play("idle")


func _exit() -> void:
	unit.animated_sprite.stop()


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass
