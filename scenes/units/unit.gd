class_name Unit
extends Area2D

signal unit_moved()
signal unit_killed()

@export var speed: float = 100.0
@export var unit_profile: UnitProfile = null
@export var size: Vector2i = Vector2i(32, 32)


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var weapon_muzzle: Marker2D = $WeaponMuzzle
@onready var hp_label_component: HPLabelComponent = $HPLabelComponent
@onready var explosion_scene: PackedScene = preload("res://scenes/vfx/explosion.tscn")


var grid_pos: Vector2i = Vector2i.ZERO
var reachable_cells: Dictionary = {}  # Vector2i → cost
var exhausted: bool = false
var actual_health: float = 10.0

var team: Team
var facing: FaceDirection.Values

var fsm: StateMachine
var idle_state: UnitIdleState
var moving_state: UnitMovingState
var selected_state: UnitSelectedState
var done_state: UnitDoneState


func _ready() -> void:
	# Make the material unique to this instance
	animated_sprite.material = animated_sprite.material.duplicate()
	z_index = 2 # To make sure the unit is always visible


func _process(delta: float) -> void:
	fsm._process(delta)


func _physics_process(delta: float) -> void:
	fsm._physics_process(delta)


func setup(p_team: Team) -> void:
	set_team(p_team)
	actual_health = unit_profile.health
	
	idle_state = UnitIdleState.new("unit_idle", self)
	moving_state = UnitMovingState.new("unit_moving", self)
	selected_state = UnitSelectedState.new("unit_selected", self)
	done_state = UnitDoneState.new("unit_done", self)

	fsm = StateMachine.new(name, idle_state)


func set_team(p_team: Team) -> void:
	team = p_team
	facing = team.face_direction

	animated_sprite.material.set_shader_parameter("original_colors", team.team_profile.original_colors)
	animated_sprite.material.set_shader_parameter("replace_colors", team.team_profile.replace_colors)


func select() -> void:
	fsm.change_state(selected_state)


func deselect() -> void:
	fsm.change_state(idle_state)


func exhaust() -> void:
	fsm.change_state(done_state)


func ready_to_move() -> void:
	fsm.change_state(idle_state)
	

func idling() -> void:
	animated_sprite.play("idle")
	animated_sprite.flip_h = facing == FaceDirection.Values.RIGHT


func move_following_path(p: Array[Vector2]) -> void:
	if p.is_empty():
		return

	print("Unit moving along path: %s" % str(p))

	fsm.change_state(moving_state, {"path": p})


func get_terrain_cost(terrain: TerrainType.Values) -> float:
	return unit_profile.movement_profile.get_cost(terrain)


func is_max_health() -> bool:
	return actual_health >= unit_profile.health


func can_capture_building(building: Building) -> bool:
	if building.grid_pos != grid_pos:
		return false

	if team.is_same_team(building.team):
		return false

	return unit_profile.capture_capacity > 0


func capture_capacity() -> int:
	var ratio: float = actual_health / unit_profile.health

	print("ratio: ", ratio)

	return round(ratio*unit_profile.capture_capacity)


func can_merge_with_unit(unit: Unit) -> bool:
	# not on the same cell
	if unit.grid_pos != grid_pos:
		return false

	# not the same team
	if not team.is_same_team(unit.team):
		return false

	# not the same type
	if unit.unit_profile.type != unit_profile.type:
		return false

	# both of them are full hp
	if unit.is_max_health() and is_max_health():
		return false

	return true


func merge_with_unit(unit: Unit) -> void:
	actual_health += unit.actual_health

	# TODO: add funds if merge lead to reduce health
	if actual_health > unit_profile.health:
		actual_health = unit_profile.health


func take_dmg(dmg: float) -> void:
	actual_health -= dmg
	print("dmg taken %s / health left %s" %[dmg, actual_health])
	hp_label_component.update(actual_health)


func die() -> void:
	animated_sprite.visible = false

	var explosion: Explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	get_tree().root.add_child(explosion)

	await explosion.finished

	unit_killed.emit(self)


func set_attack_highlight(highlight: bool) -> void:
	print("set hihglight: ", highlight)


func attack(defender: Unit, fx_service: FXService) -> void:
	if defender.global_position.x < global_position.x:
		facing = FaceDirection.Values.LEFT
	elif defender.global_position.x < global_position.x:
		facing = FaceDirection.Values.RIGHT

	animated_sprite.flip_h = facing == FaceDirection.Values.RIGHT
	animation_player.play("attack")
	unit_profile.weapon._play_fire(self, defender, fx_service)

	await animation_player.animation_finished


func play_hit_reaction() -> void:
	var tween: Tween = create_tween()
	var pos: Vector2 = animated_sprite.position

	# shake
	tween.tween_property(animated_sprite, "position:x", animated_sprite.position.x + 4, 0.05).set_trans(Tween.TRANS_SINE)
	tween.tween_property(animated_sprite, "position:x", animated_sprite.position.x - 4, 0.05)

	# blink
	tween.parallel().tween_property(animated_sprite, "modulate", Color(1,1,1,0.2), 0.05)
	tween.parallel().tween_property(animated_sprite, "modulate", Color.WHITE, 0.05)

	await tween.finished

	animated_sprite.position = pos
