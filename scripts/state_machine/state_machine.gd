class_name StateMachine
extends RefCounted

var current_state: State = null
var name: String

func _init(p_name: String, initial_state: State) -> void:
	name = p_name
	current_state = initial_state
	current_state._enter()
	

func change_state(new_state: State, enter_params: Dictionary = {}) -> void:
	if current_state != null:
		current_state._exit()
	
	if new_state != null:
		new_state._enter(enter_params)

	print("StateMachine [%s] - State changed from %s to: %s" % [name, str(current_state), str(new_state)])
	current_state = new_state


func _process(delta: float) -> void:
	current_state._process(delta)


func _physics_process(delta: float) -> void:
	current_state._physics_process(delta)