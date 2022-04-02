extends State

"""
In the Idle state a character will... TODO
"""


func enter(_msg: Dictionary = {}):
	_parent.enter()


func unhandled_input(event: InputEvent):
	_parent.unhandled_input(event)


func physics_process(delta: float):
	_parent.physics_process(delta)
	
	if _parent.input_direction != Vector2.ZERO:
		# Walking
		for _input in ["move_up", "move_left", "move_down", "move_right"]:
			if Input.is_action_pressed(_input):
				_state_machine.transition_to("Movement/Moving")


func exit():
	_parent.exit()
