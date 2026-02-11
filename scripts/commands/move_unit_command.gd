class_name MoveUnitCommand
extends Command

var unit: Unit
var units_manager: UnitsManager
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


func execute():
	unit.cell_pos = target_cell
	units_manager.confirm_unit_movement()
	unit.move_following_path(path)


func undo():
	unit.cell_pos = start_cell
	units_manager.revert_unit_movement()
	unit.select()
	if capture_process != null:
		unit.capture_process = CaptureProcess.load_from_capture_process(capture_process)
		capture_process = null
