class_name UIController
extends CanvasLayer

@export var units_manager: UnitsManager
@export var grid: Grid

@onready var cancel_button: Button = $Control/MarginContainer/HBoxContainer/MainPanel/CancelButton

@onready var action_panel: HBoxContainer = $Control/MarginContainer/HBoxContainer/ActionPanel 
@onready var idle_button: Button = $Control/MarginContainer/HBoxContainer/ActionPanel/IdleButton
@onready var attack_button: Button = $Control/MarginContainer/HBoxContainer/ActionPanel/AttackButton


var fsm: StateMachine
var idle_state: UIIdleState
var selected_state: UISelectedState
var moved_state: UIMovedState

func _ready() -> void:
	idle_state = UIIdleState.new("ui_idle", self)
	selected_state = UISelectedState.new("ui_selected", self)
	moved_state = UIMovedState.new("ui_moved", self)

	fsm = StateMachine.new(name, idle_state)

	grid.cell_clicked.connect(on_cell_clicked)

	units_manager.unit_selected.connect(on_unit_selected)
	units_manager.unit_deselected.connect(on_unit_deselected)
	units_manager.unit_moved.connect(on_unit_moved)

	cancel_button.pressed.connect(on_cancel_clicked)
	idle_button.pressed.connect(on_idle_clicked)


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


func on_idle_clicked() -> void:
	units_manager.confirm_unit_movement()
	fsm.change_state(idle_state)

