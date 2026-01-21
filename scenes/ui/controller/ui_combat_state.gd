class_name UICombatState
extends UIState


func _enter(_params: Dictionary = {}) -> void:
	controller.game_hud.show_combat_state()
	controller.show_attack_indicator()


func _exit() -> void:
	controller.attack_indicator.clear()
	controller.movement_indicator.clear()


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass


func _on_cell_tap(cell: Vector2i) -> void:
	if controller.current_units_manager.can_attack_cell(cell):
		controller.fsm.change_state(controller.attack_preview_state)
	

func _on_cancel_clicked() -> void:
	controller.fsm.change_state(controller.moved_state)
