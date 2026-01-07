class_name GameManager
extends Node2D


signal turn_ended()

@onready var grid: Grid = $Grid
@onready var ui_controller: UIController = $UIController
@onready var terrain_node: Node2D = $Terrain
@onready var input_manager: InputManager = $Managers/InputManager


var teams: Array[Team] = []
var active_team: Team

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid.setup(input_manager, terrain_node)

	for child in get_node("Teams").get_children():
		var team :Team = child as Team 
		if (team != null and not team.neutral_team()):
			teams.append(team)
			print("team added: %s" % team.name)

	active_team = teams[0]
	active_team.start_turn()

	ui_controller.setup(self, grid)	
	

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


func get_unit_at(cell_pos: Vector2i) -> Unit:
	for team in teams:
		var unit: Unit = team.units_manager.get_unit_at(cell_pos)
		if unit != null:
			return unit

	return null
		


func get_building_at(cell_pos: Vector2i) -> Building:
	for team in teams:
		var building: Building = team.buildings_manager.get_building_at(cell_pos)
		if building != null:
			return building

	return null
