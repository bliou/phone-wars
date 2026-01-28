class_name UIIdleState
extends UIState


func _enter(_params: Dictionary = {}) -> void:
	controller.visible = controller.game_manager.active_team.is_playable()
	controller.game_hud.show_idle_state()


func _exit() -> void:
	controller.game_hud.hide_idle_state()


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass


func _on_cell_tap(cell: Vector2i) -> void:
	controller.current_units_manager.select_unit_at_position(cell)


func _on_long_press(cell: Vector2i) -> void:
	var unit: Unit = controller.game_manager.query_manager.get_unit_at(cell)
	if unit == null:
		return

	controller.game_hud.hide()

	var terrain_data: TerrainData = controller.grid.terrain_manager.get_terrain_data(unit.grid_pos)
	controller.info_preview.update(InfoPreview.InfoPreviewData.new(unit, terrain_data), unit.global_position)
	controller.info_preview.animate_in()

	unit = controller.current_units_manager.get_unit_at(cell)
	if unit == null:
		return
	
	var units: Array[Unit] = controller.current_units_manager.get_units_in_attack_range_with_movement(unit)
	var cells: Array[Vector2i] = controller.game_manager.query_manager.get_units_positions(units)
	controller.attack_indicator.show_cells(cells)
	controller.attack_indicator.highlight_units(units)


func _on_long_press_release(_cell: Vector2i) -> void:
	controller.game_hud.show()
	controller.attack_indicator.clear()
	controller.info_preview.animate_out()

	
func _on_cancel_clicked() -> void:
	pass
