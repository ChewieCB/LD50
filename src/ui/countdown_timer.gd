extends Control

signal game_over

onready var timer = $Timer
onready var label = $CountdownLabel

export (int) var start_time = 5


func _ready():
	CountdownTimer.connect("add_time", self, "add_time")
	timer.start(start_time)


func _process(_delta):
	label.text = convert_seconds_to_clock(timer.time_left)


func convert_seconds_to_clock(raw_seconds):
	var _seconds_total = int(raw_seconds)
	var _minutes = int(_seconds_total / 60)
	var _seconds = _seconds_total - (60 * _minutes)
	var output_string = "%02d:%02d" % [_minutes, _seconds]
	
	return output_string


func add_time(value):
	timer.start(timer.time_left + value)


func _on_Timer_timeout():
	timer.stop()
	self.visible = false
	CountdownTimer.game_over()
