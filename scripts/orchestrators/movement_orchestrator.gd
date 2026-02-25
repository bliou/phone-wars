class_name MovementOrchestrator


var audio_service: AudioService

func _init(audio: AudioService) -> void:
	audio_service = audio


func execute(units_manager: UnitsManager, target_cell: Vector2i) -> void:
	var selected_unit: Unit = units_manager.selected_unit
	var id: int = audio_service.play_loop(selected_unit.move_sound(), selected_unit.global_position)
	units_manager.move_unit_to_cell(target_cell)
	await units_manager.unit_moved
	audio_service.stop(id)

