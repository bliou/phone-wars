class_name PreviewState
extends State

var unit: Unit
var movement_intent: MovementIntent

func _init(state_name: String, p_unit: Unit) -> void:
	super._init(state_name)
	unit = p_unit


func _enter(params: Dictionary = {}) -> void:
	unit.animated_sprite.play("move_right")
	movement_intent = params.get("movement_intent", null)
	if movement_intent == null:
		unit.fsm.change_state(unit.idle_state)
		return

	unit.unit_previewed.emit(movement_intent.path)
		

func _exit() -> void:
	unit.animated_sprite.stop()


func _process(_delta: float) -> void:
	pass

	
func _physics_process(_delta: float) -> void:
	pass

	