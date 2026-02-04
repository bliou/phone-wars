class_name Weapon
extends Resource

@export var fire_scene: PackedScene
@export var hit_scene: PackedScene
@export var fire_sound: AudioStream
@export var hit_sound: AudioStream

func _play_fire(_attacker: Unit, _defender: Unit, _fx_service: FXService, _audio_service: AudioService) -> void:
	pass

	
func _play_impact(_attacker: Unit, _defender: Unit, _fx_service: FXService, _audio_service: AudioService) -> void:
	pass