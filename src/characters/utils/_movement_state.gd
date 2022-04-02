extends State
# Parent state for all movement-related states for the Player
# Holds all of the base movement logic
# Child states can override this states's functions or change its properties
# This keeps the logic grouped in one location

# These should be fallback defaults
# TODO: Make these null and raise an exception to indicate bad State extension
#       to better separate movement vars.
export var max_speed = 300
export var move_speed = 150

var velocity := Vector2.ZERO
var input_direction = Vector2.ZERO


#func enter(_msg: Dictionary = {}):
#	yield(_actor.fadeout.animation_player, "animation_finished")


func physics_process(delta: float):
	# TODO - re-implement this "return to menu" signal behaviour
#	if Input.is_action_just_pressed("ui_cancel"):
#		emit_signal("main_menu")
#		yield(DynamicMusicManager, "bgm_changed")
#
#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#		var main_menu_path = "res://src/ui/main_menu/Menu.tscn"
#		var _ret = get_tree().change_scene(main_menu_path)
	
	# Debug Reset
	if Input.is_action_pressed("reset"):
		var _ret = get_tree().reload_current_scene()
	elif Input.is_action_pressed("quit"):
		get_tree().quit()
	
	# Movement
#	if GlobalFlags.PLAYER_CONTROLS_ACTIVE:
	input_direction = get_input_direction()
#	else:
#		input_direction = Vector2.ZERO
	
	velocity = calculate_velocity(velocity, input_direction, delta)
	velocity = _actor.move_and_slide(velocity)


func get_input_direction():
	return Vector2.ZERO


func calculate_velocity(velocity_current: Vector2, input_dir: Vector2, delta: float):
	var velocity_new = input_dir * move_speed
	if velocity_new.length() > max_speed:
		velocity_new = velocity_new.normalized() * max_speed
	
	return velocity_new
