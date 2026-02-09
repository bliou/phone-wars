class_name FXService
extends Node2D


var ui_fx_layer: Node2D

func _ready() -> void:
	z_index = Ordering.FX


func setup_ui(ui: Node2D) -> void:
	ui_fx_layer = ui
	ui_fx_layer.z_index = Ordering.FX
	

func play_world_fx(scene: PackedScene, world_pos: Vector2, rot: float):
	var fx: Node2D = scene.instantiate()
	fx.global_position = world_pos
	fx.rotation = rot
	add_child(fx)


func play_ui_fx(scene: PackedScene, world_pos: Vector2, rot: float):
	var fx: Node2D = scene.instantiate()
	fx.global_position = world_pos
	fx.rotation = rot
	ui_fx_layer.add_child(fx)