class_name UIMovedState
extends UIState

func _enter(_params: Dictionary = {}) -> void:
	controller.visible = true
	controller.action_panel.visible = true


func _exit() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass


func _on_cell_clicked(_cell: Vector2i) -> void:
	pass

	
func _on_cancel_clicked() -> void:
	controller.units_manager.cancel_unit_movement()
	controller.fsm.change_state(controller.selected_state)
