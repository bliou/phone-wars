class_name CombatManager


static func compute_damage(attacker: Unit, defender: Unit, defense_terrain: TerrainData) -> float:
	var atk_profile = attacker.unit_profile.attack_profile
	var def_profile = defender.unit_profile.defense_profile

	var base_dmg: float = atk_profile.get_attack_dmg(defender.unit_profile.type)
	base_dmg *= attacker.actual_health / 10.0

	var defense: float = def_profile.get_defense_vs(defender.unit_profile.type)
	base_dmg *= (1.0 - defense / 10.0)

	base_dmg *= (1.0 - defense_terrain.defense_bonus / 10.0)
	return max(1.0, int(base_dmg))
