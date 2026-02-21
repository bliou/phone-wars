class_name StartTurnOrchestrator
extends Node

var coin_audio: AudioStream = preload("res://assets/sounds/ui/sfx_coin_double8.wav")

var start_turn_animation: StartTurnAnimation
var team_display: TeamDisplay
var audio_service: AudioService

func _init(
	sta: StartTurnAnimation,
	td: TeamDisplay,
	audio: AudioService) -> void:
	start_turn_animation = sta
	team_display = td
	audio_service = audio


func execute(team: Team, new_funds: int) -> void:
	team_display.animate_out()
	
	await start_turn_animation.play(team)

	team_display.set_new_team(team)
	await team_display.animate_in()

	var id: int = audio_service.play_loop(coin_audio, team_display.global_position)
	await team_display.update_funds(new_funds) 
	audio_service.stop(id)