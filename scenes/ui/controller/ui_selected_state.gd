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
	controller.handle_unit_movement(cell)


func _on_cancel_clicked() -> void:
	controller.current_units_manager.deselect_unit()
