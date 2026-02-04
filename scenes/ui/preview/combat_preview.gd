class_name CombatPreview
extends Control

@onready var panel_container: PanelContainer = $PanelContainer
@onready var border_texture: TextureRect = $BorderAnimation
@onready var damage_preview_label: Label = $PanelContainer/MarginContainer/VBoxContainer/DamagePreview
@onready var defender_icon: TextureRect = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/DefenderIcon
@onready var defender_hp_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/DefenderHP
@onready var terrain_icon: TextureRect = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/TerrainIcon
@onready var terrain_def_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/TerrainDef


func _ready() -> void:
	modulate.a = 0.0
	scale = Vector2.ZERO

	border_texture.material = border_texture.material.duplicate()
	border_texture.material.set_shader_parameter("alpha", 0.0)
	update_border()


func _notification(what):
	if what == NOTIFICATION_RESIZED:
		update_border()


class CombatPreviewData:
	var damage_preview: float
	var defender_icon: Texture2D
	var defender_hp: float = 0
	var defender_team: Team
	var terrain_icon: Texture2D
	var terrain_def: int

	func _init(unit: Unit, terrain_data: TerrainData, estimated_damage: float) -> void:
		damage_preview = estimated_damage*10
		defender_icon = unit.unit_profile.icon.duplicate()
		defender_team = unit.team
		defender_hp = unit.actual_health
		terrain_icon = terrain_data.icon.duplicate()
		terrain_def = terrain_data.defense_bonus


func update(cpd: CombatPreviewData, target: Node2D) -> void:
	damage_preview_label.text = "-%s %%" % cpd.damage_preview
	defender_hp_label.text = "%s" %int(cpd.defender_hp)
	terrain_icon.texture = cpd.terrain_icon
	terrain_def_label.text = "+%s" %cpd.terrain_def

	update_defender_icon(cpd)

	position_dialog(target)


func update_defender_icon(cpd: CombatPreviewData) -> void:
	if cpd.defender_team.face_direction == FaceDirection.Values.RIGHT:
		var image: Image = cpd.defender_icon.get_image()
		image.flip_x() 
		cpd.defender_icon = ImageTexture.create_from_image(image)
	
	defender_icon.material.set_shader_parameter("original_colors", cpd.defender_team.team_profile.original_colors)
	defender_icon.material.set_shader_parameter("replace_colors", cpd.defender_team.team_profile.replace_colors)
	defender_icon.texture = cpd.defender_icon


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


func position_dialog(target: Node2D):
	var dialog_size: Vector2 = panel_container.size
	var viewport_size: Vector2 = get_viewport_rect().size
	var local_transform: Vector2 = target.get_screen_transform().origin
	global_position = local_transform - Vector2(0, dialog_size.y)

	var margin: float = 10.0
	# if the dialog is too high on the viewport, displays it below the unit
	if global_position.y - dialog_size.y / 2 - margin < 0:
		global_position += Vector2(0, 2*dialog_size.y)

	global_position.x = clamp(global_position.x, dialog_size.x / 2 + margin, viewport_size.x - dialog_size.x / 2 - margin)

	update_border()


func update_border():
	border_texture.position = panel_container.position
	border_texture.set_deferred("size", panel_container.size)
