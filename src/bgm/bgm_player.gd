extends Node2D

export (AudioStream) var menu_music
export (AudioStream) var game_music

onready var menu_music_player = $MenuMusic
onready var game_music_player = $GameMusic
onready var animation_player = $AnimationPlayer


func _ready():
	animation_player.play("off")
	menu_music_player.play()

func play_menu():
	animation_player.play("fade_in_menu")


func menu_to_game():
	game_music_player.play()
	animation_player.play("crossfade_menu_to_game")


