extends Node

signal add_time(value)


func _add_time(value):
	emit_signal("add_time", value)


