class_name CombatPreview
extends Control


@onready var estimated_damage_label: Label = $Panel/VBoxContainer/EstimatedDamageLabel


func _ready() -> void:
	visible = false


class CombatPreviewData:
	var estimated_damage: int

	func _init(ed: float) -> void:
		estimated_damage = int(round(ed*10))


func update(cpd: CombatPreviewData) -> void:
	estimated_damage_label.text = "%s %%" % cpd.estimated_damage