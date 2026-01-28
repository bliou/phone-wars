class_name InfoPreview
extends Control

@onready var panel_container: PanelContainer = $PanelContainer
@onready var border_texture: TextureRect = $BorderAnimation
@onready var unit_type_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/UnitType
@onready var unit_icon: TextureRect = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/UnitIcon
@onready var unit_hp_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/UnitHP
@onready var terrain_type_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/TerrainType
@onready var terrain_icon: TextureRect = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/TerrainIcon
@onready var terrain_def_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/TerrainDef


func _ready() -> void:
	modulate.a = 0.0
	scale = Vector2.ZERO

	border_texture.material = border_texture.material.duplicate()
	border_texture.material.set_shader_parameter("alpha", 0.0)
	update_border()


func _notification(what):
	if what == NOTIFICATION_RESIZED:
		update_border()


class InfoPreviewData:
	var unit_type: String
	var unit_icon: Texture2D
	var unit_hp: float = 0
	var terrain_type: String
	var terrain_icon: Texture2D
	var terrain_def: int

	func _init(unit: Unit, terrain_data: TerrainData) -> void:
		unit_type = UnitType.get_name_from_type(unit.unit_profile.type)
		unit_icon = unit.unit_profile.icon.duplicate()
		unit_hp = unit.actual_health
		terrain_type = TerrainType.get_name_from_type(terrain_data.terrain_type)
		terrain_icon = terrain_data.icon.duplicate()
		terrain_def = terrain_data.defense_bonus


func update(ipd: InfoPreviewData, target_pos: Vector2) -> void:
	unit_type_label.text = ipd.unit_type
	unit_icon.texture = ipd.unit_icon
	unit_hp_label.text = "%s" %int(ipd.unit_hp)
	terrain_type_label.text = ipd.terrain_type
	terrain_icon.texture = ipd.terrain_icon
	terrain_def_label.text = "+%s" %ipd.terrain_def

	position_dialog(target_pos)


func animate_in():
	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(self, "scale", Vector2.ONE, 0.5)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "modulate:a", 1.0, 0.5)

	# display the border
	tween.tween_method(
		func(v): border_texture.material.set_shader_parameter("alpha", v),
		0.0, 1.0, 0.15
	)


func animate_out():
	var tween = create_tween()
	tween.set_parallel(true)
	# hides the border alone
	tween.tween_method(
		func(v): border_texture.material.set_shader_parameter("alpha", v),
		1.0, 0.0, 0.2
	)

	# modulate the main panel
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.2)


func position_dialog(screen_pos: Vector2):
	var dialog_size := panel_container.size
	var viewport_size := get_viewport_rect().size


	var pos := screen_pos + Vector2(0, -dialog_size.y)

	# Clamp inside screen
	pos.x = clamp(pos.x, 0, viewport_size.x - dialog_size.x)
	pos.y = clamp(pos.y, 0, viewport_size.y - dialog_size.y)

	global_position = pos
	update_border()


func update_border():
	border_texture.position = panel_container.position
	border_texture.set_deferred("size", panel_container.size)