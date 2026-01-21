class_name UIAttackPreviewState
extends UIState


func _enter(_params: Dictionary = {}) -> void:
	controller.game_hud.show_attack_preview_state()

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