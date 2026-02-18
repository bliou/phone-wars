class_name EconomyService
extends Node


func calculate_income(team: Team) -> int:
    var total_income := 0

    for building: Building in team.buildings_manager.buildings.values():
        total_income += building.income()

    return total_income 