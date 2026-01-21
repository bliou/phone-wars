class_name UIIdleState
extends UIState


func _enter(_params: Dictionary = {}) -> void:
	controller.visible = controller.game_manager.active_team.is_playable()
	controller.game_hud.show_idle_state()
	controller.unit_preview.hide()

func _exit() -> void:
	controller.game_hud.hide_idle_state()


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass


func _on_cell_tap(cell: Vector2i) -> void:
	controller.current_units_manager.select_unit_at_position(cell)


func _on_long_press(cell: Vector2i) -> void:
	var unit: Unit = controller.current_units_manager.get_unit_at(cell)
	if unit == null:
		return

	controller.game_hud.hide()
	
	var units: Array[Unit] = controller.current_units_manager.get_units_in_attack_range_with_movement(unit)
	controller.indicators_manager.show_attack_indicator(
		controller.game_manager.query_manager.get_units_positions(units),
		units,
	)

	controller.unit_preview.update(UnitPreview.UnitPreviewData.new(unit))
	controller.unit_preview.show()


func _on_long_press_release(_cell: Vector2i) -> void:
	controller.game_hud.show()
	controller.indicators_manager.clear()
	controller.unit_preview.hide()

	
func _on_cancel_clicked() -> void:
	pass
