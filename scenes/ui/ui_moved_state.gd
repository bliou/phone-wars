class_name UIMovedState
extends UIState

func _enter(_params: Dictionary = {}) -> void:
	controller.visible = true
	controller.action_panel.visible = true
	controller.idle_button.visible = true
	controller.attack_button.visible = show_attack_button()
	controller.capture_button.visible = show_capture_button()
	controller.merge_button.visible = false

	if show_merge_button():
		controller.idle_button.visible = false
		controller.attack_button.visible = false
		controller.capture_button.visible = false
		controller.merge_button.visible = true
		

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
	var combaAv = controller.current_units_manager.combat_available()

	print("cambaAv: ", combaAv)

	return combaAv