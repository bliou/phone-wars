class_name SelectedState
extends State

var unit: Unit


func _init(state_name: String, p_unit: Unit) -> void:
	super._init(state_name)
	unit = p_unit


func _enter(_params: Dictionary = {}) -> void:
	unit.animated_sprite.play("idle")
	unit.animated_sprite.modulate = Color(0, 1, 0)  # Change color to green when selected
	unit.unit_selected.emit()


func _exit() -> void:
	unit.animated_sprite.stop()
	unit.animated_sprite.modulate = Color(1, 1, 1)  # Change color back to white when deselected
	unit.unit_deselected.emit()


func _process(_delta: float) -> void:
	pass

	
func _physics_process(_delta: float) -> void:
	pass