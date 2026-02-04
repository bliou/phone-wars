class_name Indicators
extends Node2D


@onready var attack_indicator: AttackIndicator = $AttackIndicator
@onready var movement_indicator: MovementIndicator = $MovementIndicator

func _ready() -> void:
	z_index = Ordering.INDICATORS

func setup(grid: Grid, ui_controller: UIController) -> void:
	attack_indicator.setup(grid, ui_controller)
	movement_indicator.setup(grid, ui_controller)