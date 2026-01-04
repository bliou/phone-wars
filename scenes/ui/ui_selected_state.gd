class_name UISelectedState
extends UIState

func _enter(_params: Dictionary = {}) -> void:
	controller.visible = true


func _exit() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass


func _on_cell_clicked(_cell: Vector2i) -> void:
	controller.units_manager.deselect_unit()