class_name CapturingComponent
extends Sprite2D

var original_colors: PackedColorArray

func _ready() -> void:
	visible = false

	material = material.duplicate()
	original_colors.resize(5)
	original_colors[1] = Color.from_rgba8(238, 248, 254, 255)


func setup(team: Team) -> void:
	material.set_shader_parameter("original_colors", original_colors)
	material.set_shader_parameter("replace_colors", team.team_profile.replace_colors)
