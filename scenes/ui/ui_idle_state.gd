class_name UIIdleState
extends UIState


func _enter(_params: Dictionary = {}) -> void:
	controller.visible = controller.game_manager.active_team.is_playable()
	controller.action_panel.visible = false
	controller.cancel_button.visible = false
	controller.end_turn_button.visible = true


func _exit() -> void:
	controller.cancel_button.visible = true
	controller.end_turn_button.visible = false


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass


func _on_cell_clicked(cell: Vector2i) -> void:
	controller.current_units_manager.select_unit_at_position(cell)

	
func _on_cancel_clicked() -> void:
	pass
