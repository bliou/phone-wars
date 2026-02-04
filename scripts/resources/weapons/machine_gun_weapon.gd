class_name MachineGunWeapon
extends Weapon


@export var burst_count := 5
@export var burst_interval := 0.07
@export var spread_radius := 2.0


func _play_fire(attacker: Unit, _defender: Unit, fx_service: FXService, audio_service: AudioService) -> void:
	for i in burst_count:
		spawn_bullet_flash(attacker, fx_service, audio_service)
		await attacker.get_tree().create_timer(burst_interval).timeout


func spawn_bullet_flash(attacker: Unit, fx_service: FXService, audio_service: AudioService):
	# Anchor around attacker, biased toward target
	var dir: Vector2 = Vector2(-1, 0)
	var base_pos: Vector2 = attacker.weapon_muzzle.global_position

	if attacker.facing == FaceDirection.Values.RIGHT:
		base_pos.x += attacker.size.x
		dir = Vector2(1, 0)

	var offset: Vector2 = Vector2(
		randf_range(-spread_radius, spread_radius),
		randf_range(-spread_radius, spread_radius)
	)
	
	var world_pos: Vector2 = base_pos+offset
	fx_service.spawn_combat_fx(fire_scene, world_pos, dir.angle())
	audio_service.play_sfx(fire_sound, world_pos)


func _play_impact(attacker: Unit, defender: Unit, fx_service: FXService, audio_service: AudioService) -> void:
	var attacker_facing: FaceDirection.Values = attacker.facing
	for i in burst_count:
		spawn_bullet_impact(attacker_facing, defender, fx_service, audio_service)
		await defender.get_tree().create_timer(burst_interval).timeout


func spawn_bullet_impact(attacker_facing: FaceDirection.Values, defender: Unit, fx_service: FXService, audio_service: AudioService):
	# Anchor around attacker, biased toward target
	var dir: Vector2 = Vector2(-1, 0)
	var base_pos: Vector2 = defender.global_position
	base_pos.x -= defender.size.x / 2.0 / 2.0

	if attacker_facing == FaceDirection.Values.LEFT:
		base_pos.x += defender.size.x / 2.0
		dir = Vector2(1, 0)

	var offset: Vector2 = Vector2(
		randf_range(-spread_radius, spread_radius),
		randf_range(-spread_radius, spread_radius)
	)
	
	var world_pos: Vector2 = base_pos+offset
	fx_service.spawn_combat_fx(hit_scene, world_pos, dir.angle())
	audio_service.play_sfx(hit_sound, world_pos)
