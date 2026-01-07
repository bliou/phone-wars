class_name BuildingIdleState
extends State


var building: Building

func _init(state_name: String, p_building: Building) -> void:
	super._init(state_name)
	building = p_building


func _enter(_params: Dictionary = {}) -> void:
	pass


func _exit() -> void:
	pass

func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass
