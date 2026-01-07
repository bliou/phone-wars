class_name TurnManager
extends Node2D


signal turn_ended()

var teams: Array[Team] = []
var active_team: Team

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		var team :Team = child as Team 
		if (team != null and not team.neutral_team()):
			teams.append(team)
			print("team added: %s" % team.name)

	active_team = teams[0]
	active_team.start_turn()


func end_turn() -> void:
	active_team.end_turn()
	active_team = next_team()
	active_team.start_turn()

	print("Turn ended. New team %s to play" % active_team.name)
	turn_ended.emit()


func next_team() -> Team:
	var active_team_idx :int = teams.find(active_team, 0)
	active_team_idx +=1
	if active_team_idx >= teams.size():
		active_team_idx = 0

	return teams.get(active_team_idx)