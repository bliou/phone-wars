class_name CombatDialog
extends BaseDialog

@onready var damage_preview_label: Label = $PanelContainer/MarginContainer/VBoxContainer/DamagePreview
@onready var defender_icon: TextureRect = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/DefenderIcon
@onready var defender_hp_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/DefenderHP
@onready var terrain_icon: TextureRect = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/TerrainIcon
@onready var terrain_def_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/TerrainDef

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