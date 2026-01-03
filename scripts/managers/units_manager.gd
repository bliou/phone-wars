class_name UnitsManager
extends Node2D


@export var grid: Grid
@export var input_manager: InputManager

var selected_unit: Unit = null
var planned_moved: Dictionary = {}

func _ready() -> void:
	grid.cell_clicked.connect(on_cell_clicked)	

	input_manager.end_turn.connect(on_end_turn)

func select_unit(unit: Unit) -> void:
	if selected_unit:
		selected_unit.deselect()

	selected_unit = unit
	selected_unit.select()
	selected_unit.reachable_cells = grid.get_reachable_cells(Vector2i(selected_unit.global_position / grid.cell_size), selected_unit)


func deselect_unit() -> void:
	if selected_unit:
		selected_unit.deselect()
	selected_unit = null


func on_cell_clicked(cell_position: Vector2i, _terrain: Variant, occupant: Variant) -> void:
	if occupant == null:
		move_unit_to_cell(cell_position)
		return

	if occupant is Unit:
		select_unit(occupant as Unit)
	else:
		deselect_unit()


func move_unit_to_cell(target: Vector2i) -> void:
	if selected_unit == null:
		return

	# Check if the cell is reachable
	if not selected_unit.reachable_cells.has(target):
		return

	# Check if the cell is already reserved
	if grid.reserved_cells.has(target):
		return

	var previous_cell: Vector2i = Vector2i(selected_unit.global_position / grid.cell_size)
	grid.set_unit_cell(previous_cell, null)

	var path = grid.get_world_path(selected_unit, previous_cell, target)

	var intent := MovementIntent.new()
	intent.unit = selected_unit
	intent.path = path
	intent.final_cell = target
	intent.cost = selected_unit.reachable_cells[target]

	print("Intent: ", intent)
	planned_moved[selected_unit] = intent
	grid.reserved_cells[target] = selected_unit
	selected_unit.move_intent_to(intent)


func on_end_turn() -> void:
	for intent: MovementIntent in planned_moved.values():
		intent.unit.execute_intent(intent)
		grid.set_unit_cell(intent.final_cell, intent.unit)

	planned_moved.clear()
	grid.reserved_cells.clear()
