class_name MovementIndicator
extends Node2D

const COLOR := Color(0.2, 0.6, 1.0, 0.25)

var grid: Grid
var cells: Array[Vector2i] = []


func setup(p_grid: Grid):
	grid = p_grid 


func _draw() -> void:
	for cell: Vector2i in cells:
		print("drawing for cell: %s" %cell)
		var pos: Vector2 = grid.get_world_position_from_cell(cell)
		draw_rect(
			Rect2(pos-grid.cell_size*0.5, grid.cell_size),
			COLOR,
		)


func show_cells(reachable_cells: Array[Vector2i]):
	cells = reachable_cells
	queue_redraw()


func clear():
	cells.clear()
	queue_redraw()
