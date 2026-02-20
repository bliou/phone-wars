class_name UIController
extends CanvasLayer

signal camera_pan_enabled(enabled: bool)

signal show_movement_range(reachable_cells: Array[Vector2i])
signal clear_movement_range()

signal show_attackable(cells: Array[Vector2i])
signal clear_attackable()

signal end_turn()

@onready var game_hud: GameHUD = $GameHUD
@onready var team_display: TeamDisplay = $TeamDisplay
@onready var production_panel: ProductionPanel = $ProductionPanel

@onready var capture_popup: CapturePopup = $Popups/CapturePopup
@onready var combat_popup: CombatPopup = $Popups/CombatPopup
@onready var info_popup: InfoPopup = $Popups/InfoPopup
@onready var damage_effect: DamageEffect = $Effects/DamageEffect

@onready var ui_fx_layer: Node2D = $FXLayer

var grid: Grid
var combat_orchestrator: CombatOrchestrator
var capture_orchestrator: CaptureOrchestrator
var movement_orchestrator: MovementOrchestrator
var query_manager: QueryManager

var fsm: StateMachine
var idle_state: UIIdleState
var unit_selected_state: UIUnitSelectedState
var building_selected_state: UIBuildingSelectedState
var moved_state: UIMovedState
var attack_preview_state: UIAttackPreviewState

var current_units_manager: UnitsManager
var current_buildings_manager: BuildingsManager
var is_playable: bool

func setup(p_game_manager: GameManager) -> void:
	grid = p_game_manager.grid
	combat_orchestrator = CombatOrchestrator.new(damage_effect, p_game_manager.fx_service, p_game_manager.audio_service)
	capture_orchestrator = CaptureOrchestrator.new(capture_popup, p_game_manager.fx_service, p_game_manager.audio_service)
	movement_orchestrator = MovementOrchestrator.new()
	query_manager = p_game_manager.query_manager

	switch_team(p_game_manager.active_team)

	idle_state = UIIdleState.new("ui_idle", self)
	unit_selected_state = UIUnitSelectedState.new("ui_unit_selected", self)
	building_selected_state = UIBuildingSelectedState.new("ui_building_selected", self)
	moved_state = UIMovedState.new("ui_moved", self)
	attack_preview_state = UIAttackPreviewState.new("ui_attack_preview", self)

	fsm = StateMachine.new(name, idle_state)

	p_game_manager.turn_ended.connect(on_turn_ended)

	grid.cell_short_tap.connect(on_cell_tap)
	grid.cell_long_press.connect(on_long_press)
	grid.cell_long_press_release.connect(on_long_press_release)

	game_hud.cancel_button_clicked.connect(on_cancel_clicked)
	game_hud.end_turn_button_clicked.connect(on_end_turn_clicked)

	game_hud.idle_button_clicked.connect(on_idle_clicked)
	game_hud.capture_button_clicked.connect(on_capture_clicked)
	game_hud.merge_button_clicked.connect(on_merge_clicked)
	game_hud.attack_button_clicked.connect(on_attack_clicked)

	production_panel.cancel_button_clicked.connect(on_cancel_clicked)
	production_panel.build_clicked.connect(on_build_clicked)


func on_cell_tap(cell: Vector2i) -> void:
	var state: UIState = fsm.current_state as UIState
	state._on_cell_tap(cell)


func on_long_press(cell: Vector2i) -> void:
	var state: UIState = fsm.current_state as UIState
	state._on_long_press(cell)

	
func on_long_press_release(cell: Vector2i) -> void:
	var state: UIState = fsm.current_state as UIState
	state._on_long_press_release(cell)


func on_unit_selected(_unit: Unit) -> void:
	fsm.change_state(unit_selected_state)


func on_unit_deselected(_unit: Unit) -> void:
	fsm.change_state(idle_state)


func on_building_selected() -> void:
	fsm.change_state(building_selected_state)


func on_building_deselected() -> void:
	fsm.change_state(idle_state)


func on_cancel_clicked() -> void:
	var state: UIState = fsm.current_state as UIState
	state._on_cancel_clicked()


func on_build_clicked(entry: ProductionEntry) ->void:
	var state: UIState = fsm.current_state as UIState
	state._on_build_clicked(entry)


func on_end_turn_clicked() -> void:
	fsm.change_state(idle_state)
	end_turn.emit()


func on_idle_clicked() -> void:
	current_units_manager.exhaust_unit()
	fsm.change_state(idle_state)


func on_capture_clicked() -> void:
	current_units_manager.capture_building()
	game_hud.hide()
	team_display.animate_out()
	await capture_orchestrator.execute(current_units_manager.selected_unit)
	game_hud.show()
	team_display.animate_in()
	fsm.change_state(idle_state)
	current_units_manager.exhaust_unit()


func on_merge_clicked() -> void:
	current_units_manager.merge_units()
	fsm.change_state(idle_state)


func on_attack_clicked() -> void:
	var state: UIState = fsm.current_state as UIState
	state._on_attack_clicked()
	

func on_turn_ended(new_team: Team) -> void:
	switch_team(new_team)


func switch_team(new_team: Team) -> void:
	if current_units_manager != null:
		current_units_manager.unit_selected.disconnect(on_unit_selected)
		current_units_manager.unit_deselected.disconnect(on_unit_deselected)

	current_units_manager = null
	current_units_manager = new_team.units_manager
	current_units_manager.unit_selected.connect(on_unit_selected)
	current_units_manager.unit_deselected.connect(on_unit_deselected)


	if current_buildings_manager != null:
		current_buildings_manager.building_selected.disconnect(on_building_selected)
		current_buildings_manager.building_deselected.disconnect(on_building_deselected)

	current_buildings_manager = null
	current_buildings_manager = new_team.buildings_manager
	current_buildings_manager.building_selected.connect(on_building_selected)
	current_buildings_manager.building_deselected.connect(on_building_deselected)


	is_playable = new_team.is_playable()
	team_display.update(new_team)


func show_attack_indicator() -> void:
	var units: Array[Unit] = current_units_manager.get_units_in_attack_range_with_movement(current_units_manager.selected_unit)
	var cells: Array[Vector2i] = query_manager.get_units_positions(units)
	show_attackable.emit(cells)


func show_movement_indicator() -> void:
	current_units_manager.compute_reachable_cells()
	show_movement_range.emit(current_units_manager.selected_unit.reachable_cells)


func can_move_to_cell(cell: Vector2i) -> bool:
	return current_units_manager.can_move_on_cell(cell)


func can_attack_cell(cell: Vector2i) -> bool:
	var unit: Unit = current_units_manager.selected_unit
	var cells: Array[Vector2i] = query_manager.get_cells_in_attack_range(unit)
	var enemy_unit: Unit = query_manager.get_unit_at(cell)
	return cells.has(cell) and enemy_unit != null and not enemy_unit.team.is_same_team(unit.team) 


func handle_unit_movement(cell: Vector2i) -> void:
	game_hud.hide()
	clear_attackable.emit()
	clear_movement_range.emit()
	await movement_orchestrator.execute(current_units_manager, cell)
	fsm.change_state(moved_state)


func handle_unit_attack(cell: Vector2i) -> void:
	# Selected unit can attack without moving
	if current_units_manager.can_selected_unit_attack_cell(cell):
		current_units_manager.set_target_unit(query_manager.get_unit_at(cell))
		fsm.change_state(attack_preview_state)
		return

	# Unit first need to move
	game_hud.hide()
	clear_attackable.emit()
	clear_movement_range.emit()
	var best_cell: Vector2i = current_units_manager.choose_best_attack_position(cell)
	current_units_manager.set_target_unit(query_manager.get_unit_at(cell))
	await movement_orchestrator.execute(current_units_manager, best_cell)
	fsm.change_state(moved_state)
	fsm.change_state(attack_preview_state)


func handle_long_press(cell: Vector2i) -> void:
	var unit: Unit = query_manager.get_unit_at(cell)
	var building: Building = query_manager.get_building_at(cell)

	if unit == null and building == null:
		return
		
	game_hud.hide()
	camera_pan_enabled.emit(false)
	team_display.animate_out()

	if building != null:
		info_popup.with_building(building)
	else:
		var terrain_data: TerrainData = grid.terrain_manager.get_terrain_data(unit.cell_pos)
		info_popup.with_terrain(terrain_data)

	if unit != null:
		await info_popup.with_unit(unit)
		info_popup.position_dialog(unit)
	else:
		await info_popup.clear_unit_data()
		info_popup.position_dialog(building)

	info_popup.animate_in()

	if unit == null:
		return

	var cells: Array[Vector2i] = query_manager.get_cells_in_attack_range(unit)
	show_attackable.emit(cells)


func handle_long_press_release() -> void:
	game_hud.show()
	clear_attackable.emit()
	info_popup.animate_out()
	camera_pan_enabled.emit(true)
	team_display.animate_in()


func show_combat_dialog() -> void:
	var attacker: Unit = current_units_manager.selected_unit
	var target_unit: Unit = current_units_manager.target_unit
	var building: Building = query_manager.get_building_at(target_unit.cell_pos)
	var estimated_damage: float = 0.0
	
	if building == null:
		var terrain_data: TerrainData = grid.terrain_manager.get_terrain_data(target_unit.cell_pos)
		combat_popup.with_terrain(terrain_data)
		estimated_damage = CombatManager.compute_damage(attacker, target_unit, terrain_data.defense_bonus)
	else:
		combat_popup.with_building(building)
		estimated_damage = CombatManager.compute_damage(attacker, target_unit, building.defense())

	team_display.animate_out()

	combat_popup.with_estimated_damage(estimated_damage)
	combat_popup.with_unit(target_unit)

	combat_popup.position_dialog(target_unit)
	combat_popup.animate_in()
