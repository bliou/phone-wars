class_name TeamDisplay
extends Control


@onready var money_label: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MoneyLabel
@onready var team_label: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Team


var init_pos: Vector2
var current_funds: int

func _ready() -> void:
	init_pos = position


func set_new_team(team: Team) -> void:
	team_label.text = "Team: %s"%team.team_name()
	current_funds = team.funds
	money_label.text = "Money: %s"%team.funds


func update_funds(new_funds: int) -> void:
	if current_funds == new_funds:
		return

	if new_funds < current_funds:
		await animate_funds_decrease(new_funds)
	elif new_funds > current_funds:
		await animate_funds_increase(new_funds)

	current_funds = new_funds
	money_label.modulate = Color.WHITE

func animate_funds_decrease(new_funds: int) -> void:
	var tween = create_tween()
	tween.set_parallel(true)

	var pulse_tween: Tween = pulse_color(Color.RED)

	tween.tween_method(
		func(value: int):
			money_label.text = "Money: %s"%str(value),
		current_funds,
		new_funds,
		1.5)
		
	await tween.finished
	if not pulse_tween.is_running():
		return

	await pulse_tween.finished


func animate_funds_increase(new_funds: int) -> void:
	var tween = create_tween()
	tween.set_parallel(true)

	var pulse_tween: Tween = pulse_color(Color.GREEN)

	tween.tween_method(
		func(value: int):
			money_label.text = "Money: %s"%str(value),
		current_funds,
		new_funds,
		1.5)

	await tween.finished
	if not pulse_tween.is_running():
		return

	await pulse_tween.finished


func pulse_color( color: Color) -> Tween:
	var tween = create_tween()
	tween.set_loops(5)

	tween.tween_property(money_label, "modulate", color, 0.15)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(money_label, "modulate", Color.WHITE, 0.15)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	return tween


func animate_out() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(self, "position:x", -200.0, 0.2)

	tween.tween_property(self, "modulate:a", 0.0, 0.2)

	await tween.finished


func animate_in() -> void:
	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(self, "position:x", init_pos.x, 0.2)

	tween.tween_property(self, "modulate:a", 1.0, 0.2)

	await tween.finished