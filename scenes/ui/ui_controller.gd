class_name UIController
extends CanvasLayer

@export var turn_manager: TurnManager
@export var grid: Grid

@onready var cancel_button: Button = $Control/MarginContainer/HBoxContainer/MainPanel/CancelButton
@onready var end_turn_button: Button = $Control/MarginContainer/HBoxContainer/MainPanel/EndTurnButton

@onready var action_panel: HBoxContainer = $Control/MarginContainer/HBoxContainer/ActionPanel 
@onready var idle_button: Button = $Control/MarginContainer/HBoxContainer/ActionPanel/IdleButton
@onready var attack_button: Button = $Control/MarginContainer/HBoxContainer/ActionPanel/AttackButton


var fsm: StateMachine
var idle_state: UIIdleState
var selected_state: UISelectedState
var moved_state: UIMovedState

var current_units_manager: UnitsManager

func _ready() -> void:
	idle_state = UIIdleState.new("ui_idle", self)
	selected_state = UISelectedState.new("ui_selected", self)
	moved_state = UIMovedState.new("ui_moved", self)

	fsm = StateMachine.new(name, idle_state)

	turn_manager.turn_ended.connect(on_turn_ended)

	grid.cell_clicked.connect(on_cell_clicked)

	cancel_button.pressed.connect(on_cancel_clicked)
	end_turn_button.pressed.connect(on_end_turn_clicked)

	idle_button.pressed.connect(on_idle_clicked)

	call_deferred("set_current_units_manager")


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
	turn_manager.end_turn()


func on_idle_clicked() -> void:
	turn_manager.active_team.units_manager.confirm_unit_movement()
	fsm.change_state(idle_state)


func on_turn_ended() -> void:
	set_current_units_manager()


func set_current_units_manager() -> void:
	if current_units_manager != null:
		current_units_manager.unit_selected.disconnect(on_unit_selected)
		current_units_manager.unit_deselected.disconnect(on_unit_deselected)
		current_units_manager.unit_moved.disconnect(on_unit_moved)

	current_units_manager = null

	print("active team %s" % turn_manager.active_team)
	current_units_manager = turn_manager.active_team.units_manager
	current_units_manager.unit_selected.connect(on_unit_selected)
	current_units_manager.unit_deselected.connect(on_unit_deselected)
	current_units_manager.unit_moved.connect(on_unit_moved)