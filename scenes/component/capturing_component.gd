class_name CapturingComponent
extends Sprite2D

var original_colors: PackedColorArray

func _ready() -> void:
	visible = false

	material = material.duplicate()
	original_colors.resize(5)
	original_colors[1] = Color.from_rgba8(238, 248, 254, 255)


func setup(team: Team) -> void:
	team.replace_unit_colors(material)
