class_name MachineGunWeapong
extends Weapon


@export var bullet_scene: PackedScene = preload("res://scenes/vfx/bullet.tscn")
@export var burst_count := 5
@export var burst_interval := 0.07
@export var spread_radius := 6.0


func _play_attack(attacker: Unit, _defender: Unit) -> void:
	for i in burst_count:
		spawn_bullet_flash(attacker)
		await attacker.get_tree().create_timer(burst_interval).timeout


func spawn_bullet_flash(attacker: Unit):
	var bullet: Bullet = bullet_scene.instantiate()

	# Anchor around attacker, biased toward target
	var dir: Vector2 = Vector2(-1, 0) if attacker.facing == FaceDirection.Values.LEFT else Vector2(1, 0)
	var base_pos: Vector2 = attacker.global_position + dir * 12

	var offset: Vector2 = Vector2(
		randf_range(-spread_radius, spread_radius),
		randf_range(-spread_radius, spread_radius)
	)

	bullet.global_position = base_pos + offset
	bullet.rotation = dir.angle()

	attacker.get_tree().current_scene.add_child(bullet)
