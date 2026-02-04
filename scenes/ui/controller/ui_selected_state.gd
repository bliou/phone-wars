class_name UISelectedState
extends UIState

func _enter(_params: Dictionary = {}) -> void:
	controller.visible = true
	controller.game_hud.show_selected_state()
	
	controller.show_attack_indicator()
	controller.show_movement_indicator()


func _exit() -> void:
	controller.clear_attackable.emit()
	controller.clear_movement_range.emit()


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass


func _on_cell_tap(cell: Vector2i) -> void:
	if controller.current_units_manager.can_attack_cell(cell):
		controller.fsm.change_state(controller.attack_preview_state)
		return

	if not controller.current_units_manager.selected_unit.reachable_cells.has(cell):
		return

	if controller.current_units_manager.can_move_on_cell(cell):
		controller.game_hud.hide_cancel_button()
		controller.current_units_manager.move_unit_to_cell(cell)
		controller.clear_attackable.emit()
		controller.clear_movement_range.emit()
		return


func _on_cancel_clicked() -> void:
	controller.current_units_manager.deselect_unit()
