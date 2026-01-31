class_name Canon
extends Weapon

@export var shell_scene: PackedScene

func _play_attack(attacker: Unit, _defender: Unit) -> void:
	spawn_shell(attacker)


func spawn_shell(attacker: Unit):
	var shell: Node2D = shell_scene.instantiate()

	# Anchor around attacker, biased toward target
	var dir: Vector2 = Vector2(-1, 0)
	var base_pos: Vector2 = attacker.weapon_muzzle.global_position

	if attacker.facing == FaceDirection.Values.RIGHT:
		base_pos.x += attacker.size.x
		dir = Vector2(1, 0)

	shell.global_position = base_pos
	shell.rotation = dir.angle()

	attacker.get_tree().current_scene.add_child(shell)
