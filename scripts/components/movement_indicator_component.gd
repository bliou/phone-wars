class_name MovementIndicatorComponent
extends Node2D

@onready var unit: Unit = get_parent() as Unit

const COLOR := Color(0.2, 0.6, 1.0, 0.25)

func _ready() -> void:
	visible = false
	unit.unit_selected.connect(_on_unit_selected)
	unit.unit_deselected.connect(_on_unit_deselected)


func _draw() -> void:
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

func _on_unit_selected() -> void:
	print("MovementIndicatorComponent: Unit selected, showing movement range.")
	visible = true
	queue_redraw()  # triggers _draw()


func _on_unit_deselected() -> void:
	print("MovementIndicatorComponent: Unit deselected, hiding movement range.")
	visible = false
	queue_redraw()  # triggers _draw()
