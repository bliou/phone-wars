class_name  MovingState
extends State

var unit: Unit

var path: Array[Vector2] = []
var currentPathIndex: int = 0

func _init(state_name: String, p_unit: Unit) -> void:
	super._init(state_name)
	unit = p_unit

func _enter(params: Dictionary = {}) -> void:
	unit.animated_sprite.play("walk_right")
	currentPathIndex = 0
	path = params.get("path", [])

func _exit() -> void:
	unit.animated_sprite.stop()
	path.clear()

func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if currentPathIndex >= path.size():
		unit.fsm.change_state(unit.idle_state)
		return

	var target_position = path[currentPathIndex]
	var direction: Vector2 = (target_position - unit.global_position).normalized()
	unit.global_position += direction * unit.speed * delta

	if unit.global_position.distance_to(target_position) < 1.0:
		currentPathIndex += 1

	direction = direction.snappedf((0.1))

	if direction == Vector2.RIGHT:
		unit.animated_sprite.play("walk_right")
		unit.animated_sprite.flip_h = false
	elif direction == Vector2.LEFT:
		unit.animated_sprite.play("walk_right")
		unit.animated_sprite.flip_h = true
	elif direction == Vector2.UP:
		unit.animated_sprite.play("walk_up")
	elif direction == Vector2.DOWN:
		unit.animated_sprite.play("walk_down")
