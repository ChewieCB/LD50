extends State


func enter(_msg: Dictionary = {}):
	_parent.enter()
	_actor.audio_manager.transition_to(_actor.audio_manager.States.CRASH)
	GlobalFlags.IS_PLAYER_CONTROLLABLE = false
	_actor.exhaust_sprite.visible = false
	# Wait a bit and turn the engine back on
	yield(get_tree().create_timer(0.6),"timeout")
	GlobalFlags.IS_PLAYER_CONTROLLABLE = true
	exit()


func unhandled_input(event: InputEvent):
	_parent.unhandled_input(event)


func physics_process(delta: float):
	_parent.physics_process(delta)
	
	# Idle
	if _parent.input_direction == Vector2.ZERO:
		_state_machine.transition_to("Movement/Idle")


func exit():
	_parent.exit()


func _update_sfx():
	# Only run if we are currently in the running state
	if _state_machine.state != self:
		return

