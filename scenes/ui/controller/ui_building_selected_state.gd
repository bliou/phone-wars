class_name UIBuildingSelectedState
extends UIState

func _enter(_params: Dictionary = {}) -> void:
	controller.visible = true
	controller.game_hud.hide()
	controller.production_panel.show()

	var prod_list: ProductionList = controller.current_buildings_manager.selected_building.production_list
	controller.production_panel.load_production_list(prod_list)


func _exit() -> void:
	controller.game_hud.show()
	controller.production_panel.hide()


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass


func _on_cancel_clicked() -> void:
	controller.current_buildings_manager.deselect_building()


func _on_build_clicked() -> void:
	print("build button clicked")