extends Node2D

export (AudioStream) var menu_music
export (AudioStream) var game_music_normal
export (AudioStream) var game_music_filtered
export (AudioStream) var game_music_ticker


onready var menu_music_player = $MenuMusic
#
onready var game_music_player_normal = $GameMusic/Normal
onready var game_music_player_filtered = $GameMusic/Filtered
onready var game_music_player_ticker = $GameMusic/Ticker
onready var game_music_players = [
	game_music_player_normal, 
	game_music_player_filtered, 
	game_music_player_ticker
]

onready var animation_player = $AnimationPlayer


func _ready():
	animation_player.play("off")
	menu_music_player.play()


func play_menu():
	animation_player.play("fade_in_menu")


func game_normal_to_filtered():
	animation_player.play("normal_to_filtered")


func game_filtered_to_normal():
	animation_player.play("filtered_to_normal")


func game_normal_to_ticker():
	animation_player.play("normal_to_ticker")


func game_ticker_to_normal():
	animation_player.play("ticker_to_normal")


func game_filtered_to_ticker():
	animation_player.play("filtered_to_ticker")


func game_ticker_to_filtered():
	animation_player.play("ticker_to_filtered")


func menu_to_game():
	animation_player.play("crossfade_menu_to_game")
	yield(animation_player, "animation_finished")
	game_music_player_normal.play()
	game_music_player_filtered.play()
	game_music_player_ticker.play()


