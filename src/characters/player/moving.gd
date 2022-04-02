extends State
# Basic state when the player is moving around until jumping or lack of input

export var max_speed = 300
export var move_speed = 150


func enter(_msg: Dictionary = {}):
	_parent.enter()


func unhandled_input(event: InputEvent):
	_parent.unhandled_input(event)


func physics_process(delta: float):
	_parent.physics_process(delta)
	
	if GlobalFlags.IS_PLAYER_CONTROLLABLE:
		if Input.is_action_pressed("move_left"):
				_actor.animation_player.play("left")
		elif Input.is_action_pressed("move_right"):
			_actor.animation_player.play("right")
		else:
			_actor.animation_player.play("idle")
	
	# Idle
	if _parent.input_direction == Vector2.ZERO:
		_state_machine.transition_to("Movement/Idle")


func exit():
	_parent.exit()


func _update_sfx():
	# Only run if we are currently in the running state
	if _state_machine.state != self:
		return
