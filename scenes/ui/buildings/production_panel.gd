class_name ProductionPanel
extends Control

signal cancel_button_clicked()
signal build_button_clicked()


@onready var cancel_button: Button = $PanelContainer/MarginContainer/CancelButton
@onready var build_button: Button = $PanelContainer/MarginContainer/BuildButton

@onready var production_list: VBoxContainer = $PanelContainer/MarginContainer/MarginContainer/ProductionList


func _ready() -> void:
	cancel_button.pressed.connect(func(): cancel_button_clicked.emit())
	build_button.pressed.connect(func(): build_button_clicked.emit())



func load_production_list(prod_list: ProductionList) -> void:
	print("loading prod list")


	