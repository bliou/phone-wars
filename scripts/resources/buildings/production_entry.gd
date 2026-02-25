class_name ProductionEntry
extends Resource



@export var unit_scene: PackedScene
@export var unit_profile: UnitProfile


func cost() -> int:
    return unit_profile.cost