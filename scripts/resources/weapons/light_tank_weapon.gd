class_name LightTankWeapon
extends Weapon

@export var light_tank_shell_scene: PackedScene = preload("res://scenes/vfx/light_tank_shell.tscn")
@export var spread_radius := 6.0

func _play_attack(attacker: Unit, _defender: Unit) -> void:
	spawn_shell(attacker)


func spawn_shell(attacker: Unit):
	var shell: LightTankShell = light_tank_shell_scene.instantiate()

	# Anchor around attacker, biased toward target
	var dir: Vector2 = Vector2(-1, 0) if attacker.facing == FaceDirection.Values.LEFT else Vector2(1, 0)
	var base_pos: Vector2 = attacker.global_position + dir * 12

	var offset: Vector2 = Vector2(
		randf_range(-spread_radius, spread_radius),
		randf_range(-spread_radius, spread_radius)
	)

	shell.global_position = base_pos + offset
	shell.rotation = dir.angle()

	attacker.get_tree().current_scene.add_child(shell)
