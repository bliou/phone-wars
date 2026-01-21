class_name UIController
extends CanvasLayer


@onready var game_hud: GameHUD = $GameHUD
@onready var unit_preview: UnitPreview = $Previews/UnitPreview
@onready var movement_indicator: MovementIndicator = $Indicators/MovementIndicator
@onready var attack_indicator: AttackIndicator = $Indicators/AttackIndicator


var game_manager: GameManager

var fsm: StateMachine
var idle_state: UIIdleState
var selected_state: UISelectedState
var moved_state: UIMovedState
var combat_state: UICombatState
var attack_preview_state: UIAttackPreviewState

var current_units_manager: UnitsManager

func setup(p_game_manager: GameManager, grid: Grid) -> void:
	game_manager = p_game_manager

	attack_indicator.setup(grid)
	movement_indicator.setup(grid)

	set_current_units_manager()

	idle_state = UIIdleState.new("ui_idle", self)
	selected_state = UISelectedState.new("ui_selected", self)
	moved_state = UIMovedState.new("ui_moved", self)
	combat_state = UICombatState.new("ui_combat", self)
	attack_preview_state = UIAttackPreviewState.new("ui_attack_preview", self)

	fsm = StateMachine.new(name, idle_state)

	game_manager.turn_ended.connect(on_turn_ended)

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


func on_unit_moved() -> void:
	fsm.change_state(moved_state)


func on_cancel_clicked() -> void:
	var state: UIState = fsm.current_state as UIState
	state._on_cancel_clicked()


func on_end_turn_clicked() -> void:
	fsm.change_state(idle_state)
	game_manager.end_turn()


func on_idle_clicked() -> void:
	current_units_manager.confirm_unit_movement()
	fsm.change_state(idle_state)


func on_capture_clicked() -> void:
	current_units_manager.capture_building()
	fsm.change_state(idle_state)


func on_merge_clicked() -> void:
	current_units_manager.merge_units()
	fsm.change_state(idle_state)


func on_attack_clicked() -> void:
	var state: UIState = fsm.current_state as UIState
	state._on_attack_clicked()
	

func on_turn_ended() -> void:
	set_current_units_manager()


func set_current_units_manager() -> void:
	if current_units_manager != null:
		current_units_manager.unit_selected.disconnect(on_unit_selected)
		current_units_manager.unit_deselected.disconnect(on_unit_deselected)
		current_units_manager.unit_moved.disconnect(on_unit_moved)

	current_units_manager = null

	print("active team %s" % game_manager.active_team)
	current_units_manager = game_manager.active_team.units_manager
	current_units_manager.unit_selected.connect(on_unit_selected)
	current_units_manager.unit_deselected.connect(on_unit_deselected)
	current_units_manager.unit_moved.connect(on_unit_moved)


func show_attack_indicator() -> void:
	var unit_context: UnitContext = UnitContext.create_unit_context(current_units_manager.selected_unit)
	var units: Array[Unit] = current_units_manager.get_units_in_attack_range(unit_context)
	var cells: Array[Vector2i] = game_manager.query_manager.get_units_positions(units)
	
	attack_indicator.show_cells(cells)
	attack_indicator.highlight_units(units)


func show_movement_indicator() -> void:
	var cells: Array[Vector2i] =  []
	cells.assign(current_units_manager.selected_unit.reachable_cells.keys())
	movement_indicator.show_cells(cells)