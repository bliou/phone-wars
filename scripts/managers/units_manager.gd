class_name UnitsManager
extends Node

signal unit_selected(unit: Unit)
signal unit_deselected(unit: Unit)
signal unit_moved(unit: Unit)


var grid: Grid
var query_manager: QueryManager
var selected_unit: Unit = null
var target_unit: Unit = null # cache the unit that we want to attack
var units: Dictionary = {} # Vector2i -> Unit

var move_unit_command: MoveUnitCommand

func setup(p_grid: Grid, p_query_manager: QueryManager, team: Team) -> void:
	grid = p_grid
	query_manager = p_query_manager
	init_units(team)


func init_units(team: Team) -> void:
	for unit in get_children():
		if unit is Unit:
			var cell_pos: Vector2i = Vector2i(unit.position / grid.cell_size)
			units[cell_pos] = unit
			unit.grid_pos = cell_pos
			unit.unit_moved.connect(on_unit_moved)
			unit.unit_killed.connect(on_unit_killed)
			unit.setup(team)


func remove_unit(unit: Unit) -> void:
	print("removing unit %s at %s" % [unit.name, unit.grid_pos])
	units.erase(unit)
	unit.queue_free()


func get_grid_path(unit: Unit, start_cell: Vector2i, end_cell: Vector2i) -> Array[Vector2i]:
	return Pathfinding.find_path(grid, unit, start_cell, end_cell)


func get_world_path(unit: Unit, start_cell: Vector2i, end_cell: Vector2i) -> Array[Vector2]:
	var cell_path = get_grid_path(unit, start_cell, end_cell)
	var world_path: Array[Vector2] = []
	for cell in cell_path:
		world_path.append(grid.get_world_position_from_cell(cell))
	return world_path


func select_unit(unit: Unit) -> void:
	if selected_unit:
		return

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
	if (unit == null or unit.exhausted):
		return

	select_unit(unit)


func get_unit_at(cell_position: Vector2i) -> Unit:
	return units.get(cell_position, null) as Unit


func on_unit_moved() -> void:
	unit_moved.emit()


func on_unit_killed(unit: Unit) -> void:
	remove_unit(unit)


func move_unit_to_cell(target_cell: Vector2i) -> void:
	if not can_move_on_cell(target_cell):
		return

	var previous_cell: Vector2i = Vector2i(selected_unit.global_position / grid.cell_size)

	var path = get_world_path(selected_unit, previous_cell, target_cell)
	
	move_unit_command = MoveUnitCommand.new(selected_unit, target_cell, path)
	move_unit_command.execute()


func can_move_on_cell(target_cell: Vector2i) -> bool:
	var unit_on_cell: Unit = query_manager.get_unit_at(target_cell)
	return (unit_on_cell == null or
		unit_on_cell == selected_unit or
		selected_unit.can_merge_with_unit(unit_on_cell)
	)



func cancel_unit_movement() -> void:
	move_unit_command.undo()
	selected_unit.global_position = grid.get_world_position_from_cell(selected_unit.grid_pos)
	move_unit_command = null


func confirm_unit_movement() -> void:
	units.erase(move_unit_command.start_cell)
	units[move_unit_command.target_cell] = selected_unit
	move_unit_command = null
	exhaust_unit()


func exhaust_unit() -> void:
	selected_unit.exhaust()
	selected_unit = null


func reset_units() -> void:
	for unit in units.values():
		unit.ready_to_move()


func capture_available() -> bool:
	var unit_pos: Vector2i = selected_unit.grid_pos
	var building: Building = query_manager.get_building_at(unit_pos)
	if building == null:
		return false

	return selected_unit.can_capture_building(building)


func capture_building() -> void:
	var unit_pos: Vector2i = selected_unit.grid_pos
	var building: Building = query_manager.get_building_at(unit_pos)
	building.try_to_capture_by(selected_unit)
	confirm_unit_movement()


func merge_available() -> bool:
	var unit_pos: Vector2i = selected_unit.grid_pos
	var unit: Unit = query_manager.get_unit_at(unit_pos)
	if unit == null or unit == selected_unit:
		return false

	return selected_unit.can_merge_with_unit(unit)


func merge_units() -> void:
	var unit_pos: Vector2i = selected_unit.grid_pos
	var unit: Unit = query_manager.get_unit_at(unit_pos)
	selected_unit.merge_with_unit(unit)

	remove_unit(unit)
	confirm_unit_movement()


func combat_available() -> bool:
	var attack_positions: Array[Vector2i] = get_enemy_in_range_of_attack()

	for ap in attack_positions:
		var unit: Unit = query_manager.get_unit_at(ap)
		if unit != null and unit != selected_unit and selected_unit.can_attack_unit(unit):
			return true

	return false


func attack_unit() -> void:
	selected_unit.attack_unit(target_unit)
	target_unit = null
	confirm_unit_movement()


func get_enemy_in_range_of_attack() -> Array[Vector2i]:
	var unit_pos: Vector2i = selected_unit.grid_pos
	var attack_profile: AttackProfile = selected_unit.unit_profile.attack_profile
	
	return grid.get_cells_in_manhattan_range(unit_pos, attack_profile.min_range, attack_profile.max_range)


func get_enemy_unit_on_cell(cell: Vector2i) -> Unit:
	var attack_positions: Array[Vector2i] = get_enemy_in_range_of_attack()

	for ap in attack_positions:
		var unit: Unit = query_manager.get_unit_at(ap)
		if (unit != null and
			unit.grid_pos == cell and
			unit != selected_unit and
			selected_unit.can_attack_unit(unit)):
				target_unit = unit
				return unit

	return null
