class_name SettingsHUD
extends Control

signal resume_button_clicked()
signal exit_button_clicked()


@onready var resume_button: Button = $PanelContainer/VBoxContainer/ResumeButton
@onready var exit_button: Button = $PanelContainer/VBoxContainer/ExitButton


func _ready() -> void:
	visible = false
	resume_button.pressed.connect(func(): resume_button_clicked.emit())
	exit_button.pressed.connect(func(): exit_button_clicked.emit())
