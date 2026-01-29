class_name CombatOrchestrator
extends Node

var damage_popup: DamagePopup

func set_damage_popup(dp: DamagePopup) -> void:
	damage_popup = dp


func execute(attacker: Unit, defender: Unit, terrain: TerrainData) -> void:
	var result = CombatManager.resolve_combat(attacker, defender, terrain)

	await play_attack_animation(result)
	play_defender_reaction(result)
	apply_damage(result)
	show_damage_popup(result)

	if result.defender_killed:
		handle_unit_death(result)


func play_attack_animation(result: CombatManager.CombatResult) -> void:
	await result.attacker.attack(result.defender)

	
func play_defender_reaction(result: CombatManager.CombatResult) -> void:
	result.defender.play_hit_reaction()


func show_damage_popup(result: CombatManager.CombatResult) -> void:
	damage_popup.update(result.damage)
	damage_popup.play(result.defender.global_position)

func apply_damage(result: CombatManager.CombatResult) -> void:
	result.defender.take_dmg(result.damage)


func handle_unit_death(result: CombatManager.CombatResult) -> void:
	result.defender.die()
