class_name ProductionEntryPanel
extends Control


signal build_button_clicked(entry: ProductionEntry)


@onready var unit_icon: TextureRect = $HBoxContainer/UnitIcon
@onready var unit_name: Label = $HBoxContainer/UnitName
@onready var unit_cost: Label = $HBoxContainer/UnitCost

@onready var build_button: Button = $HBoxContainer/BuildButton


func load_from_entry(entry: ProductionEntry, team: Team) -> void:
	unit_name.text = UnitType.get_name_from_type(entry.unit_profile.type)
	unit_cost.text = "%s €"%entry.cost
	unit_icon.texture = entry.unit_profile.icon.duplicate()
	team.replace_colors(unit_icon.material)
	
	build_button.pressed.connect(func(): build_button_clicked.emit(entry))
	