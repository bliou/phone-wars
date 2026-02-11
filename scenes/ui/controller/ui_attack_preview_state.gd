class_name UIAttackPreviewState
extends UIState


func _enter(_params: Dictionary = {}) -> void:
	controller.game_hud.show_attack_preview_state()
	var attacker: Unit = controller.current_units_manager.selected_unit
	var target_unit: Unit = controller.current_units_manager.target_unit
	var terrain_data: TerrainData = controller.grid.terrain_manager.get_terrain_data(target_unit.cell_pos)
	var estimated_damage: float = CombatManager.compute_damage(attacker, target_unit, terrain_data)

	controller.combat_dialog.update(CombatDialog.CombatPreviewData.new(target_unit, terrain_data, estimated_damage), target_unit)
	controller.combat_dialog.animate_in()

func _exit() -> void:
	pass

func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass


func _on_cancel_clicked() -> void:
	controller.fsm.switch_to_previous_state()
	controller.combat_dialog.animate_out()


func _on_attack_clicked() -> void:
	var attacker: Unit = controller.current_units_manager.selected_unit
	var defender: Unit = controller.current_units_manager.target_unit
	var terrain_data: TerrainData = controller.grid.terrain_manager.get_terrain_data(defender.cell_pos)

	controller.combat_dialog.animate_out()
	controller.game_hud.hide()
	await controller.combat_orchestrator.execute(attacker, defender, terrain_data)
	controller.game_hud.show()
	controller.fsm.change_state(controller.idle_state)
	controller.current_units_manager.unit_attack_done()
