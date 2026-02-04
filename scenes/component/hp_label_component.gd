class_name HPLabelComponent
extends Sprite2D


func _ready() -> void:
	visible = false


func update(health: float) -> void:
	if health >= Const.MAX_HP or health <= 0:
		visible = false
		return

	frame = round(health)
	visible = true