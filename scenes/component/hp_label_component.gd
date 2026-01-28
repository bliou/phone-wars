class_name HPLabelComponent
extends Sprite2D

const DEFAULT: StringName = "default"


func _ready() -> void:
	visible = false


func revert() -> void:
	position.x *= (-1)


func update(health: float) -> void:
	if health >= Const.MAX_HP:
		visible = false
		return

	frame = round(health)
	visible = true