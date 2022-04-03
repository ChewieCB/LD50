extends State
# Parent state for all movement-related states for the Player
# Holds all of the base movement logic
# Child states can override this states's functions or change its properties
# This keeps the logic grouped in one location

# These should be fallback defaults
# TODO: Make these null and raise an exception to indicate bad State extension
#       to better separate movement vars.
export var engine_power = 750
export var acceleration = Vector2.ZERO
export var friction = -0.3
export var drag = -0.002
#
export var braking_power = -450
export var handbrake_power = -200
export var max_speed_reverse = 250
#
export var slip_speed = 300  # Speed where traction is reduced
export var traction_drift = 0.01 # Drifting traction
export var traction_fast = 0.1  # High-speed traction
export var traction_slow = 0.7  # Low-speed traction
#
export var bounce_speed = 250 # Speed at which collisions cause the player to bounce off


export var wheel_base = 50
export var steering_angle_high = 45
export var steering_angle_low = 30
var steering_angle = steering_angle_low
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
	
	# DEBUG
#	if Input.is_action_just_pressed("add_time"):
#		CountdownTimer._add_time(30)
	
	if Input.is_action_just_pressed("kill_engine"):
		GlobalFlags.IS_PLAYER_CONTROLLABLE = !GlobalFlags.IS_PLAYER_CONTROLLABLE
	
	# Hacky sprite changing
	if GlobalFlags.IS_PLAYER_CONTROLLABLE:
		if Input.is_action_pressed("move_left"):
				_actor.animation_player.play("left")
		elif Input.is_action_pressed("move_right"):
			_actor.animation_player.play("right")
		else:
			_actor.animation_player.play("idle")
	
	# Movement
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	# Rotate to move up instead of right
	velocity += acceleration * delta
	
	# If we're going fast, bounce off the wall
	if velocity.length() > bounce_speed:
		var collision = _actor.move_and_collide(velocity * delta)
		if collision:
			# Turn off the engine for a second
			velocity = velocity.bounce(collision.normal) * 0.6
			_state_machine.transition_to("Movement/Crashing")
	else:
		velocity = _actor.move_and_slide(velocity)
	
	var collision = _actor.move_and_collide(velocity * delta)
	if collision:
		# If we're going fast, bounce off the wall
		if velocity.length() > bounce_speed:
			# Turn off the engine for a second
			velocity = velocity.bounce(collision.normal) * 0.6
			_state_machine.transition_to("Movement/Crashing")
		else:
			velocity = velocity.slide(collision.normal)
	
#	print(velocity.length())


func get_input():
	if not GlobalFlags.IS_PLAYER_CONTROLLABLE:
		_actor.exhaust_sprite.visible = false
		return
	
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
		if _state_machine.state != _state_machine.get_node("Movement/Drifting"):
			_state_machine.transition_to("Movement/Accelerating")
	if Input.is_action_pressed("move_down"):
		acceleration = _actor.transform.x * braking_power
		if velocity.length() > 0:
			_state_machine.transition_to("Movement/Decelerating")
		else:
			_state_machine.transition_to("Movement/Reversing")
	elif Input.is_action_pressed("handbrake"):
		if velocity.length() > 0:
			_state_machine.transition_to("Movement/Drifting")
			steering_angle = lerp(steering_angle, steering_angle_high, 0.2)
			acceleration = _actor.transform.x * handbrake_power
			friction = lerp(friction, -0.4, 0.5)
		else:
			steering_angle = lerp(steering_angle, steering_angle_low, 0.5)
			friction = lerp(friction, -1.4, 0.5)
	else:
		steering_angle = steering_angle_low
		friction = lerp(friction, -1.4, 0.5)


func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	if Input.is_action_pressed("handbrake"):
		friction_force *= 0.6
	acceleration += drag_force + friction_force


func calculate_steering(delta):
	if not GlobalFlags.IS_PLAYER_CONTROLLABLE:
		return
	
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



