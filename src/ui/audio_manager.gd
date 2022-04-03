extends Node

signal transitioned

# Player SFX samples
export (AudioStreamSample) var purchase

enum States { 
	PURCHASE
	}

onready var sfx_player = $SFXPlayer


func play_audio(state):
	# Match the state to the sample
	match state:
		States.PURCHASE:
			sfx_player.stream = purchase
			sfx_player.play()


func transition_to(state):
	play_audio(state)
	emit_signal("transitioned", state)

