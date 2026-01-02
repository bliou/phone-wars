class_name StateMachine
extends RefCounted

var current_state: State = null


func _init(initial_state: State) -> void:
	current_state = initial_state
	current_state._enter()
	

func change_state(new_state: State, enter_params: Dictionary = {}) -> void:
	if current_state != null:
		current_state._exit()
	
	if new_state != null:
		new_state._enter(enter_params)

	print("State changed from %s to: %s" % [str(current_state), str(new_state)])
	current_state = new_state


func _process(delta: float) -> void:
	current_state._process(delta)


func _physics_process(delta: float) -> void:
	current_state._physics_process(delta)