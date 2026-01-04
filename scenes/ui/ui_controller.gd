class_name UIController
extends CanvasLayer

@export var units_manager: UnitsManager
@export var grid: Grid

@onready var move_button: Button = $Control/MarginContainer/HBoxContainer/MoveButton


var fsm: StateMachine
var idle_state: UIIdleState
var selected_state: UISelectedState
var move_state: UIMoveState

func _ready() -> void:
	idle_state = UIIdleState.new("ui_idle", self)
	selected_state = UISelectedState.new("ui_selected", self)
	move_state = UIMoveState.new("ui_move", self)

	fsm = StateMachine.new(name, idle_state)

	grid.cell_clicked.connect(on_cell_clicked)

	units_manager.unit_selected.connect(on_unit_selected)
	units_manager.unit_deselected.connect(on_unit_deselected)

	move_button.pressed.connect(on_move_button_pressed)


func on_cell_clicked(cell: Vector2i) -> void:
	var state: UIState = fsm.current_state as UIState
	state._on_cell_clicked(cell)


func on_unit_selected(_unit: Unit) -> void:
	fsm.change_state(selected_state)


func on_unit_deselected(_unit: Unit) -> void:
	fsm.change_state(idle_state)


func on_move_button_pressed() -> void:
	fsm.change_state(move_state)
