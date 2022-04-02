extends State
# Parent state for all movement-related states for the Player
# Holds all of the base movement logic
# Child states can override this states's functions or change its properties
# This keeps the logic grouped in one location

# These should be fallback defaults
# TODO: Make these null and raise an exception to indicate bad State extension
#       to better separate movement vars.
export var engine_power = 1000
export var acceleration = Vector2.ZERO
export var friction = -1.4
export var drag = -0.001
#
export var braking_power = -450
export var handbrake_power = -150
export var max_speed_reverse = 450
#
export var slip_speed = 300  # Speed where traction is reduced
export var traction_drift = 0.01 # Drifting traction
export var traction_fast = 0.1  # High-speed traction
export var traction_slow = 0.7  # Low-speed traction


export var wheel_base = 70
export var steering_angle = 22
var steer_direction

var velocity := Vector2.ZERO
var input_direction = Vector2.ZERO
var steer_angle


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
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	# Rotate to move up instead of right
	velocity += acceleration * delta
	velocity = _actor.move_and_slide(velocity)


func get_input():
	input_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	var turn = 0
	if Input.is_action_pressed("move_right"):
		turn += 1
	if Input.is_action_pressed("move_left"):
		turn -= 1
	
	steer_angle = turn * deg2rad(steering_angle)
	
	if Input.is_action_pressed("move_up"):
		acceleration = _actor.transform.x * engine_power
	if Input.is_action_pressed("move_down"):
		acceleration = _actor.transform.x * braking_power
	elif Input.is_action_pressed("handbrake"):
		if velocity.length() > slip_speed:
			steering_angle = lerp(steering_angle, 40, 0.2)
			acceleration = _actor.transform.x * handbrake_power
			friction = lerp(friction, -0.4, 0.5)
		else:
			steering_angle = lerp(steering_angle, 22, 0.5)
			friction = lerp(friction, -1.4, 0.5)
	else:
		steering_angle = 22
		friction = lerp(friction, -1.4, 0.5)


func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += drag_force + friction_force


func calculate_steering(delta):
	var rear_wheel = _actor.position - _actor.transform.x * wheel_base / 2.0
	var front_wheel = _actor.position + _actor.transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_angle) * delta
	
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	if velocity.length() > slip_speed:
		if Input.is_action_pressed("handbrake"):
			traction = traction_drift
		else:
			traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	if d < 0:
		 velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	
	_actor.rotation = new_heading.angle()



