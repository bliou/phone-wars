class_name TeamDisplay
extends Control


@onready var money_label: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MoneyLabel
@onready var team_label: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Team


var init_pos: Vector2


func _ready() -> void:
	init_pos = position


func update(team: Team) -> void:
	money_label.text = "Money: %s"%team.funds
	team_label.text = "Team: %s"%team.team_name()


func animate_out() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(self, "position:x", -200.0, 0.2)

	tween.tween_property(self, "modulate:a", 0.0, 0.2)


func animate_in() -> void:
	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(self, "position:x", init_pos.x, 0.2)

	tween.tween_property(self, "modulate:a", 1.0, 0.2)