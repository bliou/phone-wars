class_name MovementIndicatorComponent
extends Node2D

const COLOR := Color(0.2, 0.6, 1.0, 0.25)

@onready var unit: Unit = get_parent() as Unit

func _ready() -> void:
	visible = false

func _draw() -> void:
	if unit == null:
		return

	for cell: Vector2i in unit.reachable_cells.keys():
		var offset: Vector2i = cell - unit.grid_pos
		var local_pos := Vector2(
			offset.x * unit.size.x,
			offset.y * unit.size.y
		)
		draw_rect(
			Rect2(
				local_pos - unit.size * 0.5,
				unit.size
			),
			COLOR,
			true
		)


func show_move_range():
	visible = true


func hide_move_range():
	visible = false
