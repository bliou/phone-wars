class_name DebugOverlay
extends Node2D

@export var grid: Grid
@export var show_cells: bool = true
@export var show_unit_cells: bool = true
@export var highlight_cell: Vector2i = Vector2i(-1, -1)


func _ready() -> void:
	grid.connect("cell_clicked", update_highlight)

func _draw():
	for grid_map in grid.terrain_layers:
		var cell_size = grid_map.tile_set.tile_size
			
		# Draw grid
		if show_cells:
			for cell in grid_map.get_used_cells():
				var local_pos = cell * cell_size
				draw_rect(Rect2(local_pos, cell_size), Color(1, 1, 1, 0.3), false, 1.0)

		# Draw occupied cells
		if show_unit_cells:
			for cell in grid.occupied_cells.keys():
				var local_pos = cell * cell_size
				draw_rect(Rect2(local_pos, cell_size), Color(1, 0, 0, 0.3), true)

		# Highlight a cell (e.g., mouse over)
		if highlight_cell.x != -1:
			var local_pos = highlight_cell * cell_size
			draw_rect(Rect2(local_pos, cell_size), Color(0, 1, 0, 0.3), true)


func update_highlight(cell: Vector2i, _cell: Variant) -> void:
	highlight_cell = cell
	queue_redraw()  # triggers _draw()
