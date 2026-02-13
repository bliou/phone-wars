class_name MoveUnitCommand
extends Command

var unit: Unit
var units_manager: UnitsManager
var start_cell: Vector2i
var target_cell: Vector2i
var path: Pathfinding.Path
var capture_process: CaptureProcess
var facing: FaceDirection.Values

func _init(um: UnitsManager, p_unit: Unit, p_target_cell: Vector2i, p_path: Pathfinding.Path):
	unit = p_unit
	units_manager = um
	capture_process = unit.capture_process
	start_cell = p_unit.cell_pos
	target_cell = p_target_cell
	path = p_path
	facing = unit.facing


func execute():
	unit.cell_pos = target_cell
	unit.movement_points -= path.cost
	units_manager.confirm_unit_movement(start_cell, target_cell)
	unit.move_following_path(path.world_points)


func undo():
	unit.facing = facing
	unit.cell_pos = start_cell
	unit.movement_points += path.cost
	units_manager.revert_unit_movement(start_cell, target_cell)
	unit.select()
	if capture_process != null:
		unit.capture_process = CaptureProcess.load_from_capture_process(capture_process)
		capture_process = null
