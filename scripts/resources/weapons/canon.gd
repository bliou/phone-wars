class_name Canon
extends Weapon


func _play_fire(attacker: Unit, _defender: Unit, fx_service: FXService, audio_service: AudioService) -> void:
	# Anchor around attacker, biased toward target
	var dir: Vector2 = Vector2(-1, 0)
	var base_pos: Vector2 = attacker.weapon_muzzle.global_position

	if attacker.facing == FaceDirection.Values.RIGHT:
		base_pos.x += attacker.size.x
		dir = Vector2(1, 0)

	fx_service.spawn_combat_fx(fire_scene, base_pos, dir.angle())
	audio_service.play_sfx(fire_sound, base_pos)


func _play_impact(attacker: Unit, defender: Unit, fx_service: FXService, audio_service: AudioService) -> void:
	# Anchor around attacker, biased toward target
	var dir: Vector2 = Vector2(-1, 0)

	if attacker.facing == FaceDirection.Values.LEFT:
		dir = Vector2(1, 0)

	fx_service.spawn_combat_fx(hit_scene, defender.global_position, dir.angle())
	audio_service.play_sfx(hit_sound, defender.global_position)