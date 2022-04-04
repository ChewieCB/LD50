extends Node2D

onready var player = $Player
onready var tilemap = $Nav/Floor
onready var pathfinding = $Pathfinding


func _ready():
	pathfinding.create_navigation_map(tilemap)


