extends Node

signal add_time(value)
signal game_over

var run_start_time
var run_end_time
onready var run_elapsed_str = ""

onready var is_last_30_seconds = false setget set_is_last_30_seconds


func _add_time(value):
	emit_signal("add_time", value)


func _physics_process(_delta):
	if Input.is_action_just_pressed("add_time"):
		_add_time(10)


func enter_last_30_seconds():
	print("entered ticking")
	BgmPlayer.game_normal_to_ticker()


func exit_last_30_seconds():
	print("exited ticking")
	BgmPlayer.game_ticker_to_normal()


func game_over():
	GlobalFlags.IS_PLAYER_CONTROLLABLE = false
	GlobalFlags.IS_GAME_OVER = true
	
	run_end_time = OS.get_unix_time()
	var run_time = run_end_time - run_start_time
	var minutes = run_time / 60
	var seconds = run_time % 60
	run_elapsed_str = "%02d:%02d" % [minutes, seconds]
	
	emit_signal("game_over")
	print("Game over!")


func set_is_last_30_seconds(value):
	is_last_30_seconds = value
	
	if is_last_30_seconds:
		enter_last_30_seconds()
	else:
		exit_last_30_seconds()
