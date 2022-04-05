extends Node

signal add_time(value)
signal game_over

var run_start_time
var run_end_time
onready var run_elapsed_str = ""


func _add_time(value):
	emit_signal("add_time", value)


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
