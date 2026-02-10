class_name CaptureProcess
extends Resource


class CaptureResult:
	var building: Building
	var unit: Unit

	var max_capture_points: int
	var previous_capture_points: int
	var new_capture_points: int
	var capture_done: bool


var building: Building
var unit: Unit
var capturing_component: CapturingComponent
var progress: int

func _init(build: Building, u: Unit) -> void:
	building = build
	progress = building.max_capture_points()
	unit = u
	capturing_component = u.capturing_component
	capturing_component.show()
	

static func load_from_capture_process(cp: CaptureProcess) -> CaptureProcess:
	var new_cp: CaptureProcess = CaptureProcess.new(cp.building, cp.unit)
	new_cp.progress = cp.progress

	return new_cp
	

func resolve() -> CaptureResult:
	var result: CaptureResult = CaptureResult.new()
	result.building = building
	result.unit = unit

	if unit.team.is_same_team(building.team):
		return result

	result.max_capture_points = building.max_capture_points()
	result.previous_capture_points = progress
	
	progress -= unit.capture_capacity()
	if progress <= 0:
		progress = 0
		result.capture_done = true

	result.new_capture_points = progress
	print("capture_capacity %s / progress %s" %[unit.capture_capacity(), progress])

	return result

	
func capture_done() -> void:	
	if progress > 0:
		return

	building.captured(unit.team)


func clear_capture() -> void:
	capturing_component.hide()
