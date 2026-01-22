class_name UIAttackPreviewState
extends UIState


func _enter(_params: Dictionary = {}) -> void:
	controller.game_hud.show_attack_preview_state()
	var attacker: Unit = controller.current_units_manager.selected_unit
	var target_unit: Unit = controller.current_units_manager.target_unit
	var terrain_data: TerrainData = controller.grid.terrain_manager.get_terrain_data(target_unit.grid_pos)
	var estimated_damage: float = CombatManager.compute_damage(attacker, target_unit, terrain_data)

	controller.unit_preview.update(UnitPreview.UnitPreviewData.new(target_unit))
	controller.terrain_preview.update(TerrainPreview.TerrainPreviewData.new(terrain_data))
	controller.combat_preview.update(CombatPreview.CombatPreviewData.new(estimated_damage))
	controller.unit_preview.show()
	controller.terrain_preview.show()
	controller.combat_preview.show()

func _exit() -> void:
	controller.unit_preview.hide()
	controller.terrain_preview.hide()
	controller.combat_preview.hide()


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass


func _on_cancel_clicked() -> void:
	controller.fsm.change_state(controller.fsm.previous_state)


func _on_attack_clicked() -> void:
	controller.current_units_manager.attack_unit()
	controller.fsm.change_state(controller.idle_state)