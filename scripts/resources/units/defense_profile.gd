class_name DefenseProfile
extends Resource

@export var light_defense: float = 0.0
@export var reinforced_defense: float = 0.0


func get_defense_vs(unit_type: UnitType.Values) -> float:
    if UnitType.is_light_type(unit_type):
        return light_defense
    
    return reinforced_defense