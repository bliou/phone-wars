class_name CapturingComponent
extends Sprite2D

var original_colors: PackedColorArray

func _ready() -> void:
	visible = false
	material = material.duplicate()


func setup(team: Team) -> void:
	team.replace_ui_colors(material)
