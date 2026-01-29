class_name HPLabelComponent
extends Sprite2D

const DEFAULT: StringName = "default"


func _ready() -> void:
	visible = false


func update(health: float) -> void:
	if health >= Const.MAX_HP:
		visible = false
		return

	frame = round(health)
	visible = true