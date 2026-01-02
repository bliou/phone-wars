class_name Grid
extends Node2D

signal cell_clicked(cell: Vector2i)

@export var terrain_node: Node2D

var terrain_layers: Array[TileMapLayer] = []
var occupied_cells := {}  # Vector2i → unit/building

func _ready() -> void:
	if not terrain_node:
		return
		
	for child in terrain_node.get_children():
		if child is TileMapLayer:
			terrain_layers.append(child as TileMapLayer)
			print("Added TileMapLayer:", child.name)


func set_occupied(cells: Dictionary):
	occupied_cells = cells

var soldier_selected: Soldier = null

var collision_layer_terrain: int = 1 << 0
var collision_layer_soldier: int = 1 << 1
var collision_layer_building: int = 1 << 2


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("tap_action"):
		return

	print("Tap action detected at position:", get_global_mouse_position())

	detect_terrain()

	var soldier: Soldier = detect_soldier()
	if soldier == null:
		deselect_all()
	else:
		select_soldier(soldier)


func detect_terrain():
	var space_state = get_world_2d().direct_space_state

	var query := PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.collision_mask = collision_layer_terrain

	var results = space_state.intersect_point(query, 32)
	print("Number of hits:", results.size())
	for hit in results:
		var collider = hit.collider
		print("Hit:", collider.name)

func detect_soldier() -> Soldier:
	var space_state = get_world_2d().direct_space_state

	var query := PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.collision_mask = collision_layer_soldier

	var results = space_state.intersect_point(query, 32)
	print("Number of hits:", results.size())
	for hit in results:
		var collider = hit.collider
		var soldier: Soldier = collider as Soldier
		if soldier != null:
			print("Soldier selected:", soldier.name)
			return soldier

	return null

func select_soldier(soldier: Soldier) -> void:
	deselect_all()
	soldier_selected = soldier
	soldier.select()


func deselect_all() -> void:
	if soldier_selected != null:
		soldier_selected.deselect()
	soldier_selected = null
