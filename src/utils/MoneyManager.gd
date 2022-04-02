extends Node

signal reward(value)

var current_money = 0 setget set_current_money


func set_current_money(value):
	var previous_value = current_money
	current_money = value
	# HACKY as fuck, oh well it's a jam
	emit_signal("reward", current_money - previous_value)
	
