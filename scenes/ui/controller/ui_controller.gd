class_name UIController
extends CanvasLayer

signal camera_pan_enabled(enabled: bool)

signal show_movement_range(reachable_cells: Array[Vector2i])
signal clear_movement_range()

signal show_attackable(cells: Array[Vector2i])
signal clear_attackable()

signal end_turn()

@onready var game_hud: GameHUD = $GameHUD

@onready var capture_dialog: CaptureDialog = $Dialogs/CaptureDialog
@onready var combat_dialog: CombatDialog = $Dialogs/CombatDialog
@onready var info_dialog: InfoDialog = $Dialogs/InfoDialog
@onready var damage_popup: DamagePopup = $Popups/DamagePopup

@onready var ui_fx_layer: Node2D = $FXLayer

var grid: Grid
var combat_orchestrator: CombatOrchestrator
var capture_orchestrator: CaptureOrchestrator
var movement_orchestrator: MovementOrchestrator
var query_manager: QueryManager

var fsm: StateMachine
var idle_state: UIIdleState
var selected_state: UISelectedState
var moved_state: UIMovedState
var attack_preview_state: UIAttackPreviewState

var current_units_manager: UnitsManager
var is_playable: bool

func setup(p_game_manager: GameManager) -> void:
	grid = p_game_manager.grid
	combat_orchestrator = CombatOrchestrator.new(damage_popup, p_game_manager.fx_service, p_game_manager.audio_service)
	capture_orchestrator = CaptureOrchestrator.new(capture_dialog, p_game_manager.fx_service, p_game_manager.audio_service)
	movement_orchestrator = MovementOrchestrator.new()
	query_manager = p_game_manager.query_manager

	switch_team(p_game_manager.active_team)

	idle_state = UIIdleState.new("ui_idle", self)
	selected_state = UISelectedState.new("ui_selected", self)
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
	fsm.change_state(selected_state)


func on_unit_deselected(_unit: Unit) -> void:
	fsm.change_state(idle_state)


func on_cancel_clicked() -> void:
	var state: UIState = fsm.current_state as UIState
	state._on_cancel_clicked()


func on_end_turn_clicked() -> void:
	fsm.change_state(idle_state)
	end_turn.emit()


func on_idle_clicked() -> void:
	current_units_manager.exhaust_unit()
	fsm.change_state(idle_state)


func on_capture_clicked() -> void:
	current_units_manager.capture_building()
	game_hud.hide()
	await capture_orchestrator.execute(current_units_manager.selected_unit)
	game_hud.show()
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

	is_playable = new_team.is_playable()


func show_attack_indicator() -> void:
	var units: Array[Unit] = current_units_manager.get_units_in_attack_range_with_movement(current_units_manager.selected_unit)
	var cells: Array[Vector2i] = query_manager.get_units_positions(units)
	show_attackable.emit(cells)


func show_movement_indicator() -> void:
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
	fsm.change_state(attack_preview_state)


func handle_long_press(cell: Vector2i) -> void:
	var unit: Unit = query_manager.get_unit_at(cell)
	if unit == null:
		return

	game_hud.hide()
	camera_pan_enabled.emit(false)

	var ipd: InfoDialog.InfoPreviewData = InfoDialog.InfoPreviewData.new(unit)
	var building: Building = query_manager.get_building_at(cell)
	if building != null:
		ipd.with_building(building)
		info_dialog.update(ipd, unit)
	else:
		var terrain_data: TerrainData = grid.terrain_manager.get_terrain_data(unit.cell_pos)
		ipd.with_terrain_data(terrain_data)

	info_dialog.update(ipd, unit)
	info_dialog.animate_in()

	var cells: Array[Vector2i] = query_manager.get_cells_in_attack_range(unit)
	show_attackable.emit(cells)


func handle_long_press_release() -> void:
	game_hud.show()
	clear_attackable.emit()
	info_dialog.animate_out()
	camera_pan_enabled.emit(true)
