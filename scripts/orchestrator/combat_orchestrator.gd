class_name CombatOrchestrator

var damage_popup: DamagePopup
var fx_service: FXService
var audio_service: AudioService

func _init(dp: DamagePopup, fxs: FXService, audio: AudioService) -> void:
	damage_popup = dp
	fx_service = fxs
	audio_service = audio


func execute(attacker: Unit, defender: Unit, terrain: TerrainData) -> void:
	var result = CombatManager.resolve_combat(attacker, defender, terrain)

	await play_attack_animation(result)
	await play_defender_reaction(result)
	apply_damage(result)
	show_damage_popup(result)

	if result.defender_killed:
		handle_unit_death(result)


func play_attack_animation(result: CombatManager.CombatResult) -> void:
	await result.attacker.attack(result.defender, fx_service, audio_service)

	
func play_defender_reaction(result: CombatManager.CombatResult) -> void:
	var weapon: Weapon = result.attacker.unit_profile.weapon
	weapon._play_impact(result.attacker.facing, result.defender, fx_service.play_world_fx, audio_service)
	await result.defender.play_hit_reaction()


func show_damage_popup(result: CombatManager.CombatResult) -> void:
	damage_popup.update(result.damage)
	damage_popup.play(result.defender)


func apply_damage(result: CombatManager.CombatResult) -> void:
	result.defender.take_dmg(result.damage)


func handle_unit_death(result: CombatManager.CombatResult) -> void:
	result.defender.die(audio_service)
