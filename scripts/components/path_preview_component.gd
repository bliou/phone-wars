class_name PathPreviewComponent
extends Node2D

@onready var unit: Unit = get_parent() as Unit
var path: Array[Vector2] = []

func _ready() -> void:
	unit.unit_previewed.connect(on_previewed)

func _draw() -> void:
	pass

func on_previewed(p_path: Array[Vector2]) -> void:
	path = p_path
	print("Path: ", path)
	queue_redraw()  # triggers _draw()