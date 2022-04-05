extends Node2D


onready var intro_scene = "res://src/scenes/IntroScene.tscn"


func _ready():
	BgmPlayer.play_menu()
	yield(get_tree().create_timer(2.0), "timeout")
	var _ret = get_tree().change_scene(intro_scene)

