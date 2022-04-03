extends Node

signal transitioned

# Player SFX samples
export (AudioStreamSample) var new_delivery
export (AudioStreamSample) var delivery_completed

enum States { 
	NEW_DELIVERY, DELIVERY_COMPLETED
	}

onready var sfx_player_1 = $SFXPlayer1
onready var sfx_player_2 = $SFXPlayer2


func play_audio(state):
	# Match the state to the sample
	match state:
		States.NEW_DELIVERY:
			sfx_player_1.stream = new_delivery
			sfx_player_1.play()
		States.DELIVERY_COMPLETED:
			sfx_player_1.stream = delivery_completed
			sfx_player_1.play()


func transition_to(state):
	play_audio(state)
	emit_signal("transitioned", state)

