extends Node2D


@export var grid: Grid

var selectedUnit: Soldier = null

func _ready() -> void:
	grid.cell_clicked.connect(on_cell_clicked)	

func select_unit(unit: Soldier) -> void:
	if selectedUnit:
		selectedUnit.deselect()
	selectedUnit = unit
	selectedUnit.select()

func deselect_unit() -> void:
	if selectedUnit:
		selectedUnit.deselect()
	selectedUnit = null

func on_cell_clicked(cell_position: Vector2i, _terrain: Variant, occupant: Variant) -> void:
	if occupant == null:
		move_unit_to_cell(cell_position)
		return

	if occupant is Soldier:
		select_unit(occupant as Soldier)
	else:
		deselect_unit()

func move_unit_to_cell(cell_position: Vector2) -> void:
	if selectedUnit == null:
		return

	var previous_cell: Vector2i = Vector2i(selectedUnit.global_position / grid.cell_size)
	grid.set_occupied_cell(previous_cell, null)

	var path = grid.get_world_path(previous_cell, cell_position)
	selectedUnit.move_following_path(path)

	grid.set_occupied_cell(cell_position, selectedUnit)
