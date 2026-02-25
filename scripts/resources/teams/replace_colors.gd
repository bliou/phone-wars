class_name ReplaceColors
extends Resource


@export var original_colors: PackedColorArray
@export var new_colors: PackedColorArray


func replace_colors(material: ShaderMaterial) -> void:
	if len(original_colors) == 0 or len(new_colors) == 0:
		return

	material.set_shader_parameter("original_colors", original_colors)
	material.set_shader_parameter("replace_colors", new_colors)
	