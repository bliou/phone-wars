class_name AudioService
extends Node

@export var sfx_bus: String = "SFX"


func play_sfx(stream: AudioStream, world_pos: Vector2):
	if not stream:
		return

	var player := AudioStreamPlayer2D.new()
	player.stream = stream
	player.bus = sfx_bus
	player.global_position = world_pos
	add_child(player)

	player.play()
	player.finished.connect(player.queue_free)