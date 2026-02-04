class_name AttackIndicator
extends Node2D

const COLOR := Color(1, 0, 0, 0.4)

var grid: Grid

var cells: Array[Vector2i] = []
var units: Array[Unit] = []


func setup(p_grid: Grid, ui_controller: UIController):
	grid = p_grid 

	ui_controller.show_attackable.connect(show_cells)
	ui_controller.clear_attackable.connect(clear)


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
	queue_redraw()
