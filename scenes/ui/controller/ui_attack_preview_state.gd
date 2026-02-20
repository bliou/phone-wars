class_name UIAttackPreviewState
extends UIState


func _enter(_params: Dictionary = {}) -> void:
	controller.game_hud.show_attack_preview_state()
	controller.show_combat_dialog()


func _exit() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass


func _on_cancel_clicked() -> void:
	controller.combat_popup.animate_out()
	controller.team_display.animate_in()
	controller.fsm.switch_to_previous_state()


func _on_attack_clicked() -> void:
	var attacker: Unit = controller.current_units_manager.selected_unit
	var defender: Unit = controller.current_units_manager.target_unit
	var terrain_data: TerrainData = controller.grid.terrain_manager.get_terrain_data(defender.cell_pos)
	var building: Building = controller.query_manager.get_building_at(defender.cell_pos)
	var terrain_defense: float = terrain_data.defense_bonus

	if building != null:
		terrain_defense = building.defense()

	controller.combat_popup.animate_out()
	controller.game_hud.hide()
	await controller.combat_orchestrator.execute(attacker, defender, terrain_defense)
	controller.game_hud.show()
	controller.team_display.animate_in()
	controller.fsm.change_state(controller.idle_state)
	controller.current_units_manager.unit_attack_done()
