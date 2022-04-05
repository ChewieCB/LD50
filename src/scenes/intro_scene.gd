extends Node2D

export (Array, AudioStream) var click_sfx

onready var animation_player = $AnimationPlayer
onready var sfx_player = $SFXPlayer
var scene_index setget set_scene_index


func _ready():
	animation_player.play("default")
	set_scene_index(0)


func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var rand_idx = rng.randi_range(0, click_sfx.size() - 1)
		var random_sfx = click_sfx[rand_idx]
		
		sfx_player.stream = random_sfx
		sfx_player.play()
		set_scene_index(scene_index + 1)


func set_scene_index(value):
	scene_index = value
	
	animation_player.play("scene_%s" % scene_index)
	if scene_index >= 7:
		# Get next scene
		yield(animation_player, "animation_finished")
		BgmPlayer.menu_to_game()
		get_tree().change_scene("res://src/test_scenes/TestNewTileMap.tscn")
		
