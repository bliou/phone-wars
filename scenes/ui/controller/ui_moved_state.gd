class_name UIMovedState
extends UIState

func _enter(_params: Dictionary = {}) -> void:
	controller.visible = true
	controller.game_hud.show_moved_state(
		show_capture_button(),
		show_merge_button())

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
	controller.handle_unit_movement(cell)

	
func _on_cancel_clicked() -> void:
	controller.current_units_manager.cancel_unit_movement()
	controller.fsm.switch_to_previous_state()


func _on_long_press(cell: Vector2i) -> void:
	controller.handle_long_press(cell)


func _on_long_press_release(_cell: Vector2i) -> void:
	controller.handle_long_press_release()


func show_capture_button() -> bool:
	return controller.current_units_manager.capture_available()


func show_merge_button() -> bool:
	return controller.current_units_manager.merge_available()