class_name UIMovedState
extends UIState

func _enter(_params: Dictionary = {}) -> void:
	controller.visible = true
	controller.game_hud.show_moved_state(
		show_attack_button(),
		show_capture_button(),
		show_merge_button())


func _exit() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass


func _on_cell_tap(_cell: Vector2i) -> void:
	pass

	
func _on_cancel_clicked() -> void:
	controller.current_units_manager.cancel_unit_movement()
	controller.fsm.change_state(controller.selected_state)


func _on_attack_clicked() -> void:
	controller.fsm.change_state(controller.combat_state)


func show_capture_button() -> bool:
	return controller.current_units_manager.capture_available()


func show_merge_button() -> bool:
	return controller.current_units_manager.merge_available()


func show_attack_button() -> bool:
	return controller.current_units_manager.combat_available()