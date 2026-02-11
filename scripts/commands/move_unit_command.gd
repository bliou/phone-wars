class_name MoveUnitCommand
extends Command

var unit: Unit
var start_cell: Vector2i
var target_cell: Vector2i
var path: Array[Vector2] = []
var capture_process: CaptureProcess

func _init(p_unit: Unit, p_target_cell: Vector2i, p_path: Array[Vector2]):
	unit = p_unit
	capture_process = unit.capture_process
	start_cell = p_unit.grid_pos
	target_cell = p_target_cell
	path = p_path


func execute():
	unit.grid_pos = target_cell
	unit.move_following_path(path)


func undo():
	unit.grid_pos = start_cell
	unit.select()
	if capture_process != null:
		unit.capture_process = CaptureProcess.load_from_capture_process(capture_process)
		capture_process = null
