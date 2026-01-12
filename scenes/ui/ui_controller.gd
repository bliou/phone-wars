class_name UIController
extends CanvasLayer

@onready var cancel_button: Button = $Control/MarginContainer/HBoxContainer/MainPanel/CancelButton
@onready var end_turn_button: Button = $Control/MarginContainer/HBoxContainer/MainPanel/EndTurnButton

@onready var action_panel: HBoxContainer = $Control/MarginContainer/HBoxContainer/ActionPanel 
@onready var idle_button: Button = $Control/MarginContainer/HBoxContainer/ActionPanel/IdleButton
@onready var attack_button: Button = $Control/MarginContainer/HBoxContainer/ActionPanel/AttackButton
@onready var capture_button: Button = $Control/MarginContainer/HBoxContainer/ActionPanel/CaptureButton
@onready var merge_button: Button = $Control/MarginContainer/HBoxContainer/ActionPanel/MergeButton

var game_manager: GameManager
var attack_indicator: AttackIndicator

var fsm: StateMachine
var idle_state: UIIdleState
var selected_state: UISelectedState
var moved_state: UIMovedState
var combat_state: UICombatState
var attack_preview_state: UIAttackPreviewState

var current_units_manager: UnitsManager

func setup(p_game_manager: GameManager, grid: Grid, p_attack_indicator: AttackIndicator) -> void:
	game_manager = p_game_manager
	attack_indicator = p_attack_indicator
	set_current_units_manager()

	idle_state = UIIdleState.new("ui_idle", self)
	selected_state = UISelectedState.new("ui_selected", self)
	moved_state = UIMovedState.new("ui_moved", self)
	combat_state = UICombatState.new("ui_combat", self)
	attack_preview_state = UIAttackPreviewState.new("ui_attack_preview", self)

	fsm = StateMachine.new(name, idle_state)

	game_manager.turn_ended.connect(on_turn_ended)

	grid.cell_clicked.connect(on_cell_clicked)

	cancel_button.pressed.connect(on_cancel_clicked)
	end_turn_button.pressed.connect(on_end_turn_clicked)

	idle_button.pressed.connect(on_idle_clicked)
	capture_button.pressed.connect(on_capture_clicked)
	merge_button.pressed.connect(on_merge_clicked)
	attack_button.pressed.connect(on_attack_clicked)


func on_cell_clicked(cell: Vector2i) -> void:
	var state: UIState = fsm.current_state as UIState
	state._on_cell_clicked(cell)


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