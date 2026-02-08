class_name CaptureDialog
extends BaseDialog


@onready var capture_points_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/CapturePointsLabel
@onready var max_capture_points_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MaxCapturePointsLabel
@onready var capture_points_texture: TextureRect = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/CapturePoints


class CaptureData:
    var capture_points: int
    var max_capture_points: int
    var target: Node2D
    
    func _init(capture_process: CaptureProcess) -> void:
        capture_points = capture_process.progress
        max_capture_points = capture_process.building.capture_points
        target = capture_process.building


func update(cd: CaptureData) -> void:
    var tween = create_tween()
    tween.set_parallel(true)

    max_capture_points_label.text = "%s" % cd.max_capture_points


    tween.tween_method(
        func(value: float):
            capture_points_label.text = str(int(round(value))),
        float(capture_points_label.text),
        cd.capture_points,
        1.5)

    var ratio: float = cd.capture_points as float / cd.max_capture_points
    print("ratio: ", ratio)
    tween.tween_property(
        capture_points_texture,
        "scale:x",
        ratio,
        1.5)

    await tween.finished