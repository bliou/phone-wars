class_name MusicService
extends Node

signal track_finished


@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const MUSIC_DB: float = 0.0
const SILENT_DB: float = -80.0
const MUSIC_BUS: String = "Music"
const FADE_IN_ANIM: String = "fade_in"
const FADE_OUT_ANIM: String = "fade_out"

func _ready() -> void:
	audio_player.bus = MUSIC_BUS
	audio_player.finished.connect(func(): track_finished.emit())


func play_track(track: AudioStream, fade_in: float) -> void:
	if audio_player.stream == track:
		return

	audio_player.stream = track
	audio_player.volume_db = MUSIC_DB if fade_in <= 0.0 else SILENT_DB
	audio_player.play()

	if fade_in > 0.0:
		play_fade(FADE_IN_ANIM, fade_in)


func fade_out(fade_out_time: float) -> void:
	play_fade(FADE_OUT_ANIM, fade_out_time)


func stop() -> void:
	audio_player.stop()


func play_fade(anim_name: String, duration: float) -> void:
	if not animation_player.has_animation(anim_name):
		push_error("Missing animation: %s" % anim_name)
		return

	stop_fade()

	var animation := animation_player.get_animation(anim_name)
	duration = max(duration, 0.01)
	animation_player.speed_scale = animation.length / duration
	animation_player.play(anim_name)
	

func stop_fade() -> void:
	if animation_player.is_playing():
		animation_player.stop()
