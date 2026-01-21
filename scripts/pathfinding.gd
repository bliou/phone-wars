class_name Pathfinding


static func find_path(grid: Grid, unit: Unit, start: Vector2i, target: Vector2i) -> Array[Vector2i]:
	var open := [start]
	var came_from := {}
	var cost_so_far := { start: 0.0 }

	while open.size() > 0:
		open.sort_custom(func(a, b):
			return cost_so_far[a] < cost_so_far[b]
		)

		var current = open.pop_front()
		if current == target:
			break

		for next in grid.get_neighbors(current):
			# cannot walk on this terrain
			var terrain: TerrainType.Values = grid.terrain_manager.get_terrain_type(next)
			var step_cost = unit.get_terrain_cost(terrain)
			if step_cost == INF:
				continue
				
			# cannot walk through enemy units
			var enemy_unit: Unit = grid.query_manager.get_unit_at(next)
			if enemy_unit != null and not enemy_unit.team.is_same_team(unit.team):
				continue

			var new_cost = cost_so_far[current] + step_cost
			if not cost_so_far.has(next) or new_cost < cost_so_far[next]:
				cost_so_far[next] = new_cost
				came_from[next] = current
				open.append(next)

	return reconstruct_path(came_from, start, target)


static func reconstruct_path(came_from: Dictionary, start: Vector2i, goal: Vector2i) -> Array[Vector2i]:
	var current = goal
	var path: Array[Vector2i] = []
	while current != start:
		path.append(current)
		if not came_from.has(current):
			return []  # no path found
		current = came_from[current]
	path.append(start)
	path.reverse()
	return path
