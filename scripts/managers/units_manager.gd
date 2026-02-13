class_name UnitsManager
extends Node

signal unit_selected(unit: Unit)
signal unit_deselected(unit: Unit)
signal unit_moved(unit: Unit)


var grid: Grid
var query_manager: QueryManager
var selected_unit: Unit = null
var target_unit: Unit = null
var units: Dictionary = {} # Vector2i -> Unit

var move_unit_commands: Array[MoveUnitCommand]

func setup(p_grid: Grid, p_query_manager: QueryManager, team: Team) -> void:
	grid = p_grid
	query_manager = p_query_manager
	init_units(team)


func init_units(team: Team) -> void:
	for unit in get_children():
		if unit is Unit:
			var cell_pos: Vector2i = Vector2i(unit.position / grid.cell_size)
			units[cell_pos] = unit
			unit.cell_pos = cell_pos
			unit.position = Vector2(cell_pos) * grid.cell_size + grid.cell_size*0.5
			unit.unit_moved.connect(on_unit_moved)
			unit.unit_killed.connect(on_unit_killed)
			unit.setup(team)


func remove_unit(unit: Unit) -> void:
	print("removing unit %s at %s" % [unit.name, unit.cell_pos])
	units.erase(unit.cell_pos)
	unit.queue_free()


func get_grid_path(unit: Unit, start_cell: Vector2i, end_cell: Vector2i) -> Pathfinding.Path:
	return Pathfinding.find_path(grid, unit, start_cell, end_cell)


func get_world_path(unit: Unit, start_cell: Vector2i, end_cell: Vector2i) -> Pathfinding.Path:
	var path: Pathfinding.Path = get_grid_path(unit, start_cell, end_cell)
	var world_path: Array[Vector2] = []
	for cell in path.points:
		world_path.append(grid.get_world_position_from_cell(cell))
	
	path.world_points = world_path
	return path


func select_unit(unit: Unit) -> void:
	if selected_unit:
		return

	selected_unit = unit
	selected_unit.select()
	compute_reachable_cells()
	unit_selected.emit(selected_unit)


func compute_reachable_cells() -> void:
	selected_unit.reachable_cells = grid.get_reachable_cells(selected_unit)


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


func has_unit(unit: Unit) -> bool:
	return units.get(unit.cell_pos, null) != null


func on_unit_moved() -> void:
	unit_moved.emit()


func on_unit_killed(unit: Unit) -> void:
	remove_unit(unit)


func move_unit_to_cell(target_cell: Vector2i) -> void:
	var previous_cell: Vector2i = Vector2i(selected_unit.global_position / grid.cell_size)

	var path: Pathfinding.Path = get_world_path(selected_unit, previous_cell, target_cell)
	
	var move_unit_command: MoveUnitCommand = MoveUnitCommand.new(self, selected_unit, target_cell, path)
	move_unit_command.execute()
	move_unit_commands.append(move_unit_command)


func can_move_on_cell(target_cell: Vector2i) -> bool:
	if not selected_unit.reachable_cells.has(target_cell):
		return false

	var unit_on_cell: Unit = query_manager.get_unit_at(target_cell)
	return (unit_on_cell == null or
		unit_on_cell == selected_unit or
		selected_unit.can_merge_with_unit(unit_on_cell)
	)


func cancel_unit_movement() -> void:
	var move_unit_command: MoveUnitCommand = move_unit_commands.pop_back()
	move_unit_command.undo()
	move_unit_command = null


func confirm_unit_movement(start_cell: Vector2i, target_cell: Vector2i) -> void:
	units.erase(start_cell)
	units[target_cell] = selected_unit


func revert_unit_movement(start_cell: Vector2i, target_cell: Vector2i) -> void:
	selected_unit.global_position = grid.get_world_position_from_cell(selected_unit.cell_pos)
	units.erase(target_cell)
	units[start_cell] = selected_unit
	

func exhaust_unit() -> void:
	selected_unit.exhaust()
	selected_unit = null
	move_unit_commands.clear()


func reset_units() -> void:
	for unit in units.values():
		unit.ready_to_move()


func capture_available() -> bool:
	var unit_pos: Vector2i = selected_unit.cell_pos
	var building: Building = query_manager.get_building_at(unit_pos)
	if building == null:
		return false

	return selected_unit.can_capture_building(building)


func capture_building() -> void:
	var unit_pos: Vector2i = selected_unit.cell_pos
	var building: Building = query_manager.get_building_at(unit_pos)
	selected_unit.start_capture(building)


func merge_available() -> bool:
	var unit_pos: Vector2i = selected_unit.cell_pos
	var unit: Unit = query_manager.get_unit_at(unit_pos)
	if unit == null or unit == selected_unit:
		return false

	return selected_unit.can_merge_with_unit(unit)


func merge_units() -> void:
	var unit_pos: Vector2i = selected_unit.cell_pos
	var unit: Unit = query_manager.get_unit_at(unit_pos)
	selected_unit.merge_with_unit(unit)

	remove_unit(unit)
	exhaust_unit()


func unit_attack_done() -> void:
	target_unit = null
	exhaust_unit()


func get_cells_in_direct_attack_range(unit_context: UnitContext) -> Array[Vector2i]:
	return grid.get_cells_in_manhattan_range(
		unit_context.grid_pos,
		unit_context.min_range,
		unit_context.max_range)


func get_units_in_attack_range(unit_context: UnitContext) -> Array[Unit]:
	var attacked_units: Array[Unit] = []
	var attack_positions: Array[Vector2i] = get_cells_in_direct_attack_range(unit_context)
	for ap in attack_positions:
		var unit: Unit = query_manager.get_unit_at(ap)
		if (unit != null and
			unit.cell_pos != unit_context.grid_pos and
			not unit_context.team.is_same_team(unit.team)):
				attacked_units.append(unit)

	return attacked_units


func get_units_in_attack_range_with_movement(unit: Unit) -> Array[Unit]:
	var targets: Array[Unit]
	var unit_context: UnitContext = UnitContext.create_unit_context(unit)

	if not unit.can_attack_after_movement():
		if unit.movement_points != unit.max_movement_points():
			return targets
		return get_units_in_attack_range(unit_context)
		
	var reachable_cells: Array[Vector2i] = grid.get_reachable_cells(unit)
	reachable_cells.append(unit.cell_pos)

	for cell in reachable_cells:
		unit_context.grid_pos = cell
		targets.assign(merge_unique(targets, get_units_in_attack_range(unit_context)))

	return targets


func can_attack_cell(unit_context: UnitContext, cell: Vector2i) -> bool:
	var targets: Array[Unit] = get_units_in_attack_range(unit_context)

	for unit in targets:
		if unit.cell_pos == cell:
			return true

	return false


# get all the cells that a unit can attack withing it's attack range
# with movement taken into account
func get_cells_in_attack_range(unit: Unit) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	var reachable_cells: Array[Vector2i] = grid.get_reachable_cells(unit)
	var unit_context: UnitContext = UnitContext.create_unit_context(unit)

	if not unit.can_attack_after_movement():
		if unit.movement_points != unit.max_movement_points():
			return cells
		return get_cells_in_direct_attack_range(unit_context)

	reachable_cells.append(unit.cell_pos)
	for cell in reachable_cells:
		unit_context.grid_pos = cell
		cells.assign(merge_unique(cells, get_cells_in_direct_attack_range(unit_context)))
		
	return cells


func merge_unique(a: Array, b: Array) -> Array:
	var dict := {}
	for v in a:
		dict[v] = true
	for v in b:
		dict[v] = true
	return dict.keys()


func set_target_unit(unit: Unit) -> void:
	target_unit = unit


func can_selected_unit_attack_cell(cell: Vector2i) -> bool:
	if (not selected_unit.can_attack_after_movement() and
		selected_unit.movement_points != selected_unit.max_movement_points()):
		return false

	var unit_context: UnitContext = UnitContext.create_unit_context(selected_unit)
	return can_attack_cell(unit_context, cell)


func choose_best_attack_position(target_cell: Vector2i) -> Vector2i:
	var candidates: Array[Vector2i] = get_attack_positions_after_movement(selected_unit, target_cell)

	var best_cell: Vector2i
	var best_score: int = int(-INF)

	for cell in candidates:
		var score: int = score_cell_for_attack(cell)

		if score > best_score:
			best_score = score
			best_cell = cell

	return best_cell


func get_attack_positions_after_movement(unit: Unit, target_cell: Vector2i) -> Array[Vector2i]:
	if not unit.can_attack_after_movement() and unit.movement_points != unit.max_movement_points():
		return []
		
	var unit_context: UnitContext = UnitContext.create_unit_context(unit)
	var reachable_cells: Array[Vector2i] = grid.get_reachable_cells(unit)
	var valid_positions: Array[Vector2i] = []

	for cell in reachable_cells:
		unit_context.grid_pos = cell
		if can_attack_cell(unit_context, target_cell):
			valid_positions.append(cell)

	return valid_positions


func score_cell_for_attack(cell: Vector2i) -> int:
	var building: Building = query_manager.get_building_at(cell)
	if building != null:
		return building.defense()

	var terrain_data: TerrainData = grid.terrain_manager.get_terrain_data(cell)
	return terrain_data.defense_bonus