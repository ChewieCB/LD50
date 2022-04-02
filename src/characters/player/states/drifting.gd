extends State


func enter(_msg: Dictionary = {}):
	_parent.enter()
	_actor.exhaust_sprite.visible = false


func unhandled_input(event: InputEvent):
	_parent.unhandled_input(event)


func physics_process(delta: float):
	_parent.physics_process(delta)
	
	if Input.is_action_pressed("move_left"):
			_actor.animation_player.play("left")
	elif Input.is_action_pressed("move_right"):
		_actor.animation_player.play("right")
	else:
		_actor.animation_player.play("idle")
	
	if Input.is_action_just_released("handbrake"):
		_state_machine.transition_to("Movement/Moving")
	
	# Idle
	if _parent.input_direction == Vector2.ZERO:
		_state_machine.transition_to("Movement/Idle")


func exit():
	_parent.exit()


func _update_sfx():
	# Only run if we are currently in the running state
	if _state_machine.state != self:
		return
