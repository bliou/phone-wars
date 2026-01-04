class_name UIMoveState
extends UIState


func _enter(_params: Dictionary = {}) -> void:
	controller.units_manager.request_move()


func _exit() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass


func _on_cell_clicked(cell: Vector2i) -> void:
	if not controller.units_manager.selected_unit.reachable_cells.has(cell):
		return

	controller.units_manager.move_unit_to_cell(cell)

	
