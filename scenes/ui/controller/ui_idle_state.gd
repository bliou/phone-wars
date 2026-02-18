class_name UIIdleState
extends UIState


func _enter(_params: Dictionary = {}) -> void:
	controller.visible = controller.is_playable
	controller.production_panel.hide()
	controller.game_hud.show_idle_state()
	controller.camera_pan_enabled.emit(true)


func _exit() -> void:
	controller.game_hud.hide_idle_state()
	controller.camera_pan_enabled.emit(false)


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass


func _on_cell_tap(cell: Vector2i) -> void:
	if controller.query_manager.get_unit_at(cell):
		controller.current_units_manager.select_unit_at_position(cell)

	if controller.query_manager.get_building_at(cell):
		controller.current_buildings_manager.select_building_at_position(cell)


func _on_long_press(cell: Vector2i) -> void:
	controller.handle_long_press(cell)


func _on_long_press_release(_cell: Vector2i) -> void:
	controller.game_hud.show()
	controller.handle_long_press_release()

	
func _on_cancel_clicked() -> void:
	pass
