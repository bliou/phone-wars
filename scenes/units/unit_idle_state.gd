class_name UnitIdleState
extends State

var unit: Unit

func _init(state_name: String, p_unit: Unit) -> void:
	super._init(state_name)
	unit = p_unit


func _enter(_params: Dictionary = {}) -> void:
	print("entering idle state")
	unit.idling()


func _exit() -> void:
	unit.animated_sprite.stop()


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass
