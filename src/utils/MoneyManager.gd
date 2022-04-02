extends Node

signal reward(value)
signal purchase(value)

var current_money = 0 setget set_current_money


func _physics_process(_delta):
	if Input.is_action_pressed("reset"):
		set_current_money(0)


func set_current_money(value):
	var previous_value = current_money
	current_money = value
	# HACKY as fuck, oh well it's a jam
	var diff = current_money - previous_value
	if diff > 0:
		emit_signal("reward", diff)
	elif diff < 0:
		emit_signal("purchase", diff)
	
