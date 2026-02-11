class_name MoveUnitCommand
extends Command

var unit: Unit
var units_manager: UnitsManager
var previous_movement_points: int
var start_cell: Vector2i
var target_cell: Vector2i
var path: Array[Vector2] = []
var capture_process: CaptureProcess

func _init(um: UnitsManager, p_unit: Unit, p_target_cell: Vector2i, p_path: Array[Vector2]):
	unit = p_unit
	units_manager = um
	capture_process = unit.capture_process
	start_cell = p_unit.cell_pos
	target_cell = p_target_cell
	path = p_path
	previous_movement_points = unit.movement_points


func execute():
	unit.cell_pos = target_cell
	unit.movement_points -= path.size() - 1
	units_manager.confirm_unit_movement(start_cell, target_cell)
	unit.move_following_path(path)


func undo():
	unit.cell_pos = start_cell
	unit.movement_points = previous_movement_points
	units_manager.revert_unit_movement(start_cell, target_cell)
	unit.select()
	if capture_process != null:
		unit.capture_process = CaptureProcess.load_from_capture_process(capture_process)
		capture_process = null
