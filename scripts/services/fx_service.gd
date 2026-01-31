class_name FXService
extends Node2D



func spawn_combat_fx(scene: PackedScene, world_pos: Vector2, rot: float):
	var fx: Node2D = scene.instantiate()
	fx.global_position = world_pos
	fx.rotation = rot
	add_child(fx)