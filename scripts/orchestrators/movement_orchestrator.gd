class_name MovementOrchestrator


func execute(units_manager: UnitsManager, target_cell: Vector2i) -> void:
	units_manager.move_unit_to_cell(target_cell)
	await units_manager.unit_moved

