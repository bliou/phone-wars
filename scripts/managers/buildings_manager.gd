class_name BuildingsManager
extends Node

var grid: Grid
var query_manager: QueryManager
var selected_building: Building = null
var buildings: Dictionary = {} # Vector2i -> Unit

func setup(p_grid: Grid, p_query_manager: QueryManager, team: Team) -> void:
	grid = p_grid
	query_manager = p_query_manager
	init_buildings(team)


func init_buildings(team: Team) -> void:
	for building in get_children():
		if building is Building:
			var cell_pos: Vector2i = Vector2i(building.position / grid.cell_size)
			buildings[cell_pos] = building
			building.cell_pos = cell_pos
			building.setup(team)
			print("adding building %s at %s" % [building.name, building.cell_pos])
			

func get_building_at(cell_pos: Vector2i) -> Building:
	return buildings.get(cell_pos, null) as Building


func remove_building(building: Building) -> void:
	print("removing building %s at %s" % [building.name, building.cell_pos])
	buildings.erase(building)
	remove_child(building)


func add_building(building: Building) -> void:
	var cell_pos: Vector2i = Vector2i(building.position / grid.cell_size)
	buildings[cell_pos] = building
	building.cell_pos = cell_pos

	add_child(building)
	print("adding building %s at %s" % [building.name, building.cell_pos])
			

func select_building_at_position(cell: Vector2i) -> void:
	var building: Building = buildings.get(cell, null)
	if building == null or not building.can_be_selected():
		return

	select_building(building)


func select_building(building: Building) -> void:
	if selected_building:
		return

	selected_building = building


func deselect_building() -> void:
	if selected_building == null:
		return

	selected_building = null
