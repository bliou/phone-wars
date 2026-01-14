class_name UIAttackPreviewState
extends UIState


func _enter(_params: Dictionary = {}) -> void:
	controller.action_panel.visible = true
	controller.idle_button.visible = false
	controller.capture_button.visible = false
	controller.merge_button.visible = false
	controller.attack_button.visible = true
	controller.cancel_button.visible = true
	controller.end_turn_button.visible = false


func _exit() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass


func _on_cancel_clicked() -> void:
	controller.fsm.change_state(controller.fsm.previous_state)


func _on_attack_clicked() -> void:
	controller.current_units_manager.attack_unit()
	controller.fsm.change_state(controller.idle_state)