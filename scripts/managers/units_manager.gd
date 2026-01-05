class_name UnitsManager
extends Node2D

signal unit_selected(unit: Unit)
signal unit_deselected(unit: Unit)
signal unit_moved(unit: Unit)


@export var grid: Grid

var selected_unit: Unit = null
var units: Dictionary = {} # Vector2i -> Unit

var move_unit_command: MoveUnitCommand

func _ready() -> void:
	init_units()


func init_units() -> void:
	for unit in get_children():
		if unit is Unit:
			var cell_pos: Vector2i = Vector2i(unit.position / grid.cell_size)
			units[cell_pos] = unit
			unit.grid_pos = cell_pos
			unit.unit_moved.connect(on_unit_moved)


func get_grid_path(unit: Unit, start_cell: Vector2i, end_cell: Vector2i) -> Array[Vector2i]:
	if has_unit_on_cell(end_cell):
		return []

	return Pathfinding.find_path(grid, unit, start_cell, end_cell)


func get_world_path(unit: Unit, start_cell: Vector2i, end_cell: Vector2i) -> Array[Vector2]:
	var cell_path = get_grid_path(unit, start_cell, end_cell)
	var world_path: Array[Vector2] = []
	for cell in cell_path:
		world_path.append(grid.get_world_position_from_cell(cell))
	return world_path


func select_unit(unit: Unit) -> void:
	if selected_unit:
		selected_unit.deselect()

	selected_unit = unit
	selected_unit.select()
	unit_selected.emit(selected_unit)


func request_move() -> void:
	if selected_unit == null:
		return

	selected_unit.reachable_cells = grid.get_reachable_cells(Vector2i(selected_unit.global_position / grid.cell_size), selected_unit)
	selected_unit.movement_indicator.show_move_range()
	

func deselect_unit() -> void:
	if selected_unit:
		selected_unit.deselect()
	unit_deselected.emit(selected_unit)
	selected_unit = null


func select_unit_at_position(cell_position: Vector2i) -> void:
	var unit: Unit = units.get(cell_position, null)
	if unit == null:
		return

	select_unit(unit)


func has_unit_on_cell(cell_position: Vector2i) -> bool:
	return units.has(cell_position)


func on_unit_moved() -> void:
	unit_moved.emit()


func move_unit_to_cell(target_cell: Vector2i) -> void:
	var previous_cell: Vector2i = Vector2i(selected_unit.global_position / grid.cell_size)

	var path = get_world_path(selected_unit, previous_cell, target_cell)
	
	move_unit_command = MoveUnitCommand.new(selected_unit, target_cell, path)
	move_unit_command.execute()


func cancel_unit_movement() -> void:
	move_unit_command.undo()
	selected_unit.global_position = grid.get_world_position_from_cell(selected_unit.grid_pos)
	move_unit_command = null


func confirm_unit_movement() -> void:
	units[move_unit_command.start_cell] = null
	units[move_unit_command.target_cell] = selected_unit
	move_unit_command = null

	deselect_unit()
