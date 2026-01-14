class_name GameManager
extends Node2D


signal turn_ended()

@onready var grid: Grid = $Grid
@onready var ui_controller: UIController = $UIController
@onready var terrain_node: Node2D = $Terrain
@onready var input_manager: InputManager = $Managers/InputManager
@onready var attack_indicator: AttackIndicator = $AttackIndicator


var teams: Array[Team] = []
var active_team: Team
var query_manager: QueryManager = QueryManager.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_teams()


	grid.setup(input_manager, query_manager, terrain_node)
	attack_indicator.setup(grid)
	ui_controller.setup(self, grid, attack_indicator)
	

func init_teams() -> void:
	var units_managers: Array[UnitsManager] = []
	var buildings_managers: Array[BuildingsManager] = []

	for child in get_node("Teams").get_children():
		var team :Team = child as Team 
		if team != null:
			teams.append(team)
			team.setup(grid, query_manager)
			units_managers.append(team.units_manager)
			buildings_managers.append(team.buildings_manager)
			print("team added: %s" % team.name)

	query_manager.setup(units_managers, buildings_managers)

	active_team = teams[0]
	active_team.start_turn()


func end_turn() -> void:
	active_team.end_turn()
	active_team = next_team(active_team)
	active_team.start_turn()

	print("Turn ended. New team %s to play" % active_team.name)
	turn_ended.emit()


func next_team(current_team: Team) -> Team:
	var active_team_idx :int = teams.find(current_team, 0)
	active_team_idx +=1
	if active_team_idx >= teams.size():
		active_team_idx = 0

	var team: Team = teams.get(active_team_idx)
	if team.neutral_team():
		return next_team(team)
	
	return team
