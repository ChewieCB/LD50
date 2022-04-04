extends Node2D

onready var animation_player = $AnimationPlayer
var scene_index setget set_scene_index


func _ready():
	animation_player.play("default")
	set_scene_index(0)


func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		set_scene_index(scene_index + 1)


func set_scene_index(value):
	scene_index = value
	
	animation_player.play("scene_%s" % scene_index)
	if scene_index >= 7:
		# Get next scene
		yield(animation_player, "animation_finished")
		get_tree().change_scene("res://src/test_scenes/TestNewTileMap.tscn")
		
