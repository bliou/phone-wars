class_name GameManager
extends Node2D


signal turn_ended(new_team: Team)

@onready var grid: Grid = $Grid
@onready var ui_controller: UIController = $UIController
@onready var camera_controller: CameraController = $CameraController
@onready var terrain_manager: TerrainManager = $Terrain
@onready var indicators: Indicators = $Indicators
@onready var input_manager: InputManager = $Managers/InputManager
@onready var music_manager: MusicManager = $Managers/MusicManager
@onready var fx_service: FXService = $Services/FXService
@onready var audio_service: AudioService = $Services/AudioService
@onready var music_service: MusicService = $Services/MusicService
@onready var economy_service: EconomyService = $Services/EconomyService

var teams: Array[Team] = []
var active_team: Team
var query_manager: QueryManager = QueryManager.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_teams()

	grid.setup(input_manager, query_manager, terrain_manager)
	camera_controller.setup(ui_controller, input_manager)
	indicators.setup(grid, ui_controller)
	ui_controller.setup(self)
	fx_service.setup_ui(ui_controller.ui_fx_layer)
	music_manager.setup(music_service)

	ui_controller.end_turn.connect(on_end_turn)
	

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
	var new_income: int = economy_service.calculate_income(active_team)
	active_team.start_turn(new_income)


func on_end_turn() -> void:
	active_team.end_turn()
	active_team = next_team(active_team)

	var new_income: int = economy_service.calculate_income(active_team)
	active_team.start_turn(new_income)

	print("Turn ended. New team %s to play" % active_team.name)
	turn_ended.emit(active_team)


func next_team(current_team: Team) -> Team:
	var active_team_idx :int = teams.find(current_team, 0)
	active_team_idx +=1
	if active_team_idx >= teams.size():
		active_team_idx = 0

	var team: Team = teams.get(active_team_idx)
	if team.neutral_team():
		return next_team(team)
	
	return team
