class_name CaptureOrchestrator

var capture_dialog: CaptureDialog
var fx_service: FXService
var audio_service: AudioService


func _init(cd: CaptureDialog, fxs: FXService, audio: AudioService) -> void:
	capture_dialog = cd
	fx_service = fxs
	audio_service = audio


func execute(unit: Unit) -> void:
	unit.capture()
	
	await play_capture_animation(unit.capture_process)
	await capture_dialog.animate_out()
	clear_dialog()

	if not unit.capture_process.is_capture_done():
		return

	# play something as capture animation
	unit.capture_process.capture_done()
	unit.stop_capture()


func play_capture_animation(capture_process: CaptureProcess) -> void:
	var capture_data: CaptureDialog.CaptureData = CaptureDialog.CaptureData.new(capture_process)
	await capture_dialog.position_dialog(capture_data.target)
	capture_dialog.load_unit_proxy(capture_process.unit)
	await capture_dialog.animate_in()
	await capture_dialog.play_unit_attack(fx_service, audio_service)
	await capture_dialog.update(capture_data)


func clear_dialog() -> void:
	capture_dialog.unit_proxy.clear()