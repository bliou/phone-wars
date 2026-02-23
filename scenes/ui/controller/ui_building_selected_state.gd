class_name UIBuildingSelectedState
extends UIState

func _enter(_params: Dictionary = {}) -> void:
	controller.visible = true
	controller.game_hud.hide()
	controller.production_panel.show()
	controller.team_display.animate_out()

	var selected_building: Building = controller.current_buildings_manager.selected_building
	controller.production_panel.load_production_list(
		selected_building.production_list, 
		selected_building.team)
	controller.show_selection_indicator()


func _exit() -> void:
	controller.game_hud.show()
	controller.production_panel.hide()
	controller.team_display.animate_in()
	controller.clear_selected.emit()


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass


func _on_cancel_clicked() -> void:
	deselect_building()


func _on_build_clicked(entry: ProductionEntry) -> void:
	var selected_building: Building = controller.current_buildings_manager.selected_building
	var team: Team = selected_building.team
	if not team.can_buy(entry):
		return
	
	controller.production_panel.hide()
	await controller.team_display.animate_in()
	await controller.buy_unit_orchestrator.execute(team, entry, selected_building.cell_pos)
	deselect_building()


func deselect_building() -> void:
	controller.current_buildings_manager.deselect_building()
	controller.fsm.change_state(controller.idle_state)