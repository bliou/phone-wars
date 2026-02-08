class_name CaptureOrchestrator

var capture_dialog: CaptureDialog
var audio_service: AudioService


func _init(cd: CaptureDialog, audio: AudioService) -> void:
	capture_dialog = cd
	audio_service = audio


func execute(unit: Unit) -> void:
	unit.capture()
	
	await play_capture_animation(unit.capture_process)

	capture_dialog.animate_out()

	if not unit.capture_process.is_capture_done():
		return

	# play something as capture animation
	unit.capture_process.capture_done()
	unit.stop_capture()


func play_capture_animation(capture_process: CaptureProcess) -> void:
	var capture_data: CaptureDialog.CaptureData = CaptureDialog.CaptureData.new(capture_process)
	await capture_dialog.position_dialog(capture_data.target)
	await capture_dialog.animate_in()
	await capture_dialog.update(capture_data)
