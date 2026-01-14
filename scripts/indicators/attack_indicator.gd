class_name AttackIndicator
extends Node2D

const COLOR := Color(1, 0, 0, 0.4)

var grid: Grid

var cells: Array[Vector2i] = []
var units: Array[Unit] = []


func setup(p_grid: Grid):
	grid = p_grid 


func _draw() -> void:
	for cell in cells:
		var pos: Vector2 = grid.get_world_position_from_cell(cell)
		draw_rect(
			Rect2(pos-grid.cell_size*0.5, grid.cell_size),
			COLOR,
		)


func show_cells(new_cells: Array[Vector2i]):
	cells = new_cells
	queue_redraw()


func clear():
	cells.clear()
	clear_highlight_units()
	queue_redraw()


func highlight_units(p_units: Array[Unit]):
	units = p_units
	for u: Unit in p_units:
		u.set_attack_highlight(true)


func clear_highlight_units():
	for u: Unit in units:
		u.set_attack_highlight(false)

	units.clear()