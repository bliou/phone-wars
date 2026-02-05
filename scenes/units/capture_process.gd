class_name CaptureProcess
extends Resource

var building: Building
var unit: Unit
var capturing_component: CapturingComponent
var progress: int

func _init(build: Building, u: Unit) -> void:
	building = build
	progress = building.capture_point
	unit = u
	capturing_component = u.capturing_component
	capturing_component.show()
	

static func load_from_capture_process(cp: CaptureProcess) -> CaptureProcess:
	var new_cp: CaptureProcess = CaptureProcess.new(cp.building, cp.unit)
	new_cp.progress = cp.progress

	return new_cp

func capture_building() -> bool:
	if unit.team.is_same_team(building.team):
		return false

	progress -= unit.capture_capacity()
	print("capture_capacity %s / progress %s" %[unit.capture_capacity(), progress])
	if progress > 0:
		return false

	building.captured(unit.team)

	return true


func clear_capture() -> void:
	capturing_component.hide()