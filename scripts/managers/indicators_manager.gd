class_name IndicatorsManager
extends Node


@onready var attack_indicator: AttackIndicator = $AttackIndicator
@onready var movement_indicator: MovementIndicator = $MovementIndicator


func setup(grid: Grid) -> void:
	attack_indicator.setup(grid)
	movement_indicator.setup(grid)


func clear():
	attack_indicator.clear()
	movement_indicator.clear()


func show_attack_indicator(cells: Array[Vector2i], units: Array[Unit]) -> void:
	attack_indicator.show_cells(cells)
	attack_indicator.highlight_units(units)


func show_movement_indicator(unit: Unit) -> void:
	var cells: Array[Vector2i] =  []
	cells.assign(unit.reachable_cells.keys())
	movement_indicator.show_cells(cells)
