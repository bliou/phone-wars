class_name BuildingsManager
extends Node


var grid: Grid
var selected_building: Building = null
var buildings: Dictionary = {} # Vector2i -> Unit

func setup(p_grid: Grid, team: Team) -> void:
	grid = p_grid
	init_buildings(team)


func init_buildings(team: Team) -> void:
	for building in get_children():
		if building is Building:
			var cell_pos: Vector2i = Vector2i(building.position / grid.cell_size)
			buildings[cell_pos] = building
			building.grid_pos = cell_pos
			building.setup(team)
			print("adding building %s at %s" % [building.name, building.grid_pos])
