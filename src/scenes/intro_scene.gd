extends Node2D

export (Array, AudioStream) var click_sfx

onready var animation_player = $AnimationPlayer
onready var sfx_player = $SFXPlayer
var scene_index = 0 setget set_scene_index


func _ready():
	# Play the default animation to hide the UI then stop it so we can properly
	# load the first scene in the animation.
	animation_player.play("default")
	animation_player.stop()
	set_scene_index(0)


func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		# Pick a random clacky noise
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var rand_idx = rng.randi_range(0, click_sfx.size() - 1)
		var random_sfx = click_sfx[rand_idx]
		#
		sfx_player.stream = random_sfx
		sfx_player.play()
		# Update the scene
		set_scene_index(scene_index + 1)


func set_scene_index(value):
	scene_index = value
	
	# Skip to the end of the animation if one is already playing
	if animation_player.is_playing():
		animation_player.seek(animation_player.current_animation_length, true)
		# We don't want to advance here, just skip to the end of the animation, so
		# we bump the scene_index back 1 and exit
		scene_index -= 1
		return
	
	if scene_index <= 7:
		animation_player.play("scene_%s" % scene_index)
	
	if scene_index == 7:
		# Get next scene
		BgmPlayer.menu_to_game()
		get_tree().change_scene("res://src/test_scenes/TestNewTileMap.tscn")
	elif scene_index > 7:
		pass
		
