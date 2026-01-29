class_name DamagePopup
extends Control


@onready var damage_label: Label = $Label


func _ready() -> void:
	modulate .a = 0.0


func update(damage: float) -> void:
	damage_label.text = "-%s" %int(round(damage))


func play(world_pos: Vector2):
	global_position = world_pos + Vector2(0, -size.y)
	modulate.a = 1.0

	var tween = create_tween()
	tween.parallel().tween_property(self, "position:y", position.y - 50, 1.5)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 1.5)
