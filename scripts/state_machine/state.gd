class_name State
extends RefCounted

var name: String

func _init(state_name: String) -> void:
    name = state_name


func _to_string() -> String:
    return "State (%s)" % name

func _enter(_params: Dictionary = {}) -> void:
    pass


func _exit() -> void:
    pass


func _process(_delta: float) -> void:
    pass


func _physics_process(_delta: float) -> void:
    pass