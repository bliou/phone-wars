class_name UISelectedState
extends UIState

func _enter(_params: Dictionary = {}) -> void:
	controller.visible = true
	controller.action_panel.visible = false
	controller.current_units_manager.request_move()
	
	controller.show_attack_indicator()


func _exit() -> void:
	controller.attack_indicator.clear()


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass


func _on_cell_clicked(cell: Vector2i) -> void:
	if not controller.current_units_manager.selected_unit.reachable_cells.has(cell):
		return

	if controller.current_units_manager.can_move_on_cell(cell):
		controller.current_units_manager.move_unit_to_cell(cell)
		return

	if controller.current_units_manager.can_attack_cell(cell):
		controller.fsm.change_state(controller.attack_preview_state)
		return


func _on_cancel_clicked() -> void:
	controller.current_units_manager.deselect_unit()
