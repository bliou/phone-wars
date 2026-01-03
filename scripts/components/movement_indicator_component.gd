class_name MovementIndicatorComponent
extends Node2D

@onready var unit: Unit = get_parent() as Unit

const COLOR := Color(0.2, 0.6, 1.0, 0.25)

func _ready() -> void:
	visible = false
	unit.unit_selected.connect(_on_unit_selected)
	unit.unit_deselected.connect(_on_unit_deselected)


func _draw() -> void:
	for x in range(-unit.movement_range, unit.movement_range + 1):
		for y in range(-unit.movement_range, unit.movement_range + 1):
			if abs(x) + abs(y) > unit.movement_range:
				continue  # Manhattan distance

			var cell_offset = Vector2(x, y) * unit.size
			draw_rect(
				Rect2(
					cell_offset - unit.size * 0.5,
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
