class_name UnitPreview
extends Control

@onready var unit_type: Label = $Panel/VBoxContainer/UnitType
@onready var unit_sprite: TextureRect = $Panel/VBoxContainer/UnitSprite
@onready var unit_hp: Label = $Panel/VBoxContainer/UnitHP


class UnitPreviewData:
	var type: UnitType.Values
	var icon: Texture2D
	var actual_health: int = 0
	var team: Team
	
	func _init(unit: Unit) -> void:
		type = unit.unit_profile.type
		actual_health = unit.actual_health
		icon = unit.unit_profile.icon.duplicate()
		team = unit.team
		


func update(upd: UnitPreviewData) -> void:
	unit_type.text = UnitType.get_name_from_type(upd.type)
	unit_hp.text = "%s HP" % upd.actual_health
	update_sprite(upd)


func update_sprite(upd: UnitPreviewData) -> void:
	unit_sprite.texture = upd.icon
	unit_sprite.material.set_shader_parameter("replace_color", upd.team.team_color)
	unit_sprite.flip_h = upd.team.team_face_direction == Team.FaceDirection.LEFT
