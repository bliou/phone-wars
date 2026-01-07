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
		


func get_building_at(cell_pos: Vector2i) -> Building:
	for bm in buildings_manager:
		var building: Building = bm.get_building_at(cell_pos)
		if building != null:
			return building

	return null
