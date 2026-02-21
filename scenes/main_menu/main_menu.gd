class_name MainMenu
extends Control


@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var credits_button: Button = $VBoxContainer/CreditsButton
@onready var exit_button: Button = $VBoxContainer/ExitButton

@onready var music_manager: MusicManager = $Musics/MusicManager
@onready var music_service: MusicService = $Musics/MusicService


func _ready() -> void:
	music_manager.setup(music_service)

	play_button.pressed.connect(on_play_button_pressed)
	credits_button.pressed.connect(on_credits_button_pressed)
	exit_button.pressed.connect(on_exit_button_pressed)


func on_play_button_pressed() -> void:
	pass


func on_credits_button_pressed() -> void:
	print("transition to credits screen")


func on_exit_button_pressed() -> void:
	get_tree().quit()
