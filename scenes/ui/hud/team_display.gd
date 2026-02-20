class_name TeamDisplay
extends Control


@onready var money_label: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MoneyLabel
@onready var team_label: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Team


func update(team: Team) -> void:
	money_label.text = "Money: %s"%team.funds
	team_label.text = "Team: %s"%team.team_name()
