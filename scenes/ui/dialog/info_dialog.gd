class_name InfoDialog
extends BaseDialog

@onready var unit_type_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/UnitType
@onready var unit_icon: TextureRect = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/UnitIcon
@onready var unit_hp_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/UnitHP
@onready var terrain_type_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/TerrainType
@onready var terrain_icon: TextureRect = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/TerrainIcon
@onready var terrain_def_label: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/TerrainDef


class InfoPreviewData:
	var unit_type: String
	var unit_icon: Texture2D
	var unit_hp: float = 0
	var unit_team: Team
	var terrain_type: String
	var terrain_icon: Texture2D
	var terrain_def: int

	func _init(unit: Unit) -> void:
		unit_type = UnitType.get_name_from_type(unit.unit_profile.type)
		unit_icon = unit.unit_profile.icon.duplicate()
		unit_hp = unit.actual_health
		unit_team = unit.team


	func with_building(building: Building) -> void:
		pass

	func with_terrain_data(terrain_data: TerrainData) -> void:
		terrain_type = TerrainType.get_name_from_type(terrain_data.terrain_type)
		terrain_icon = terrain_data.icon.duplicate()
		terrain_def = terrain_data.defense_bonus


func update(ipd: InfoPreviewData, target: Node2D) -> void:
	unit_type_label.text = ipd.unit_type
	unit_hp_label.text = "%s" %int(ipd.unit_hp)
	terrain_type_label.text = ipd.terrain_type
	terrain_icon.texture = ipd.terrain_icon
	terrain_def_label.text = "+%s" %ipd.terrain_def

	update_unit_icon(ipd)

	position_dialog(target)


func update_unit_icon(ipd: InfoPreviewData) -> void:
	if ipd.unit_team.face_direction == FaceDirection.Values.RIGHT:
		var image: Image = ipd.unit_icon.get_image()
		image.flip_x() 
		ipd.unit_icon = ImageTexture.create_from_image(image)
	
	unit_icon.material.set_shader_parameter("original_colors", ipd.unit_team.team_profile.original_colors)
	unit_icon.material.set_shader_parameter("replace_colors", ipd.unit_team.team_profile.replace_colors)
	unit_icon.texture = ipd.unit_icon

