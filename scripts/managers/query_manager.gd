class_name QueryManager


var units_manager: Array[UnitsManager] = []
var buildings_manager: Array[BuildingsManager] = []

func setup(p_units_manager: Array[UnitsManager], p_buildings_manager: Array[BuildingsManager]) -> void:
	units_manager = p_units_manager
	buildings_manager = p_buildings_manager
	

func get_unit_at(cell_pos: Vector2i) -> Unit:
	for um in units_manager:
		var unit: Unit = um.get_unit_at(cell_pos)
		if unit != null:
			return unit

	return null
		

func get_units_at(cells: Array[Vector2i]) -> Array[Unit]:
	var units: Array [Unit] = []
	for cell in cells:
		var unit: Unit = get_unit_at(cell)
		if unit != null:
			units.append(unit)

	return units
		

func get_units_positions(units: Array[Unit]) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []

	for unit in units:
		cells.append(unit.cell_pos)

	return cells


func get_cells_in_attack_range(unit: Unit) -> Array[Vector2i]:
	for um in units_manager:
		if um.has_unit(unit):
			return um.get_cells_in_attack_range(unit)
			
	return []


func get_building_at(cell_pos: Vector2i) -> Building:
	for bm in buildings_manager:
		var building: Building = bm.get_building_at(cell_pos)
		if building != null:
			return building

	return null


