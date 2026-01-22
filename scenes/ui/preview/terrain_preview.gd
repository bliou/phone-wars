class_name TerrainPreview
extends Control

@onready var terrain_type: Label = $Panel/VBoxContainer/TerrainType
@onready var terrain_sprite: TextureRect = $Panel/VBoxContainer/TerrainSprite
@onready var terrain_defense: Label = $Panel/VBoxContainer/TerrainDefense


func _ready() -> void:
	visible = false
	

class TerrainPreviewData:
	var type: TerrainType.Values
	var icon: Texture2D
	var defense: int

	func _init(td: TerrainData) -> void:
		type = td.terrain_type
		icon = td.icon
		defense = td.defense_bonus
		

func update(tpd: TerrainPreviewData) -> void:
	terrain_type.text = TerrainType.get_name_from_type(tpd.type)
	terrain_sprite.texture = tpd.icon
	terrain_defense.text = "Def: %s" % tpd.defense
