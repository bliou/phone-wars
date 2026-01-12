class_name UICombatState
extends UIState


func _enter(_params: Dictionary = {}) -> void:
	controller.action_panel.visible = false
	controller.cancel_button.visible = true
	controller.end_turn_button.visible = false

	show_attack_indicator()


func _exit() -> void:
	controller.attack_indicator.clear()


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass


func _on_cell_clicked(cell: Vector2i) -> void:
	var enemy: Unit = controller.current_units_manager.get_enemy_unit_on_cell(cell)
	if enemy != null:
		controller.fsm.change_state(controller.attack_preview_state)
	

func _on_cancel_clicked() -> void:
	controller.fsm.change_state(controller.moved_state)


func show_attack_indicator() -> void:
	var units: Array[Unit] = controller.current_units_manager.get_units_in_attack_range()
	var cells: Array[Vector2i] = controller.game_manager.query_manager.get_units_positions(units)
	
	controller.attack_indicator.show_cells(cells)
	controller.attack_indicator.highlight_units(units)
