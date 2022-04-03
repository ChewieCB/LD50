extends Node

signal transitioned

# Player SFX samples
export (AudioStreamSample) var accel_sfx
export (AudioStreamSample) var breakthrough_sfx
export (AudioStreamSample) var engine_sfx
export (AudioStreamSample) var top_speed_sfx
export (AudioStreamSample) var decel_sfx
export (AudioStreamSample) var drift_sfx
export (AudioStreamSample) var crash_sfx

enum States { 
	# Null state to stop looping samples
	IDLE,
	# Player SFX States
	ACCELERATING, TOP_SPEED, DECELERATING, DRIFTING, CRASH
	}

enum PlayerIDs {
	ENGINE_LOOP,
	ACCEL,
	DECEL,
	DRIFT,
	CRASH,
	BREAKTHROUGH
}

onready var tween = $Tween
onready var sfx_players = get_children()

var engine_player
var accel_player
var decel_player
var drift_player
var crash_player
var breakthrough_player


func _ready():
	sfx_players.erase(tween)
	
	engine_player = sfx_players[PlayerIDs.ENGINE_LOOP]
	engine_player.stream = engine_sfx
	# Set initial engine params
	engine_player.volume_db = -20
	engine_player.pitch_scale = 0.5
	engine_player.play()
	#
	accel_player = sfx_players[PlayerIDs.ACCEL]
	accel_player.stream = accel_sfx
	accel_player.volume_db = -80
	
	decel_player = sfx_players[PlayerIDs.DECEL]
	decel_player.stream = decel_sfx
	decel_player.volume_db = -80
	
	drift_player = sfx_players[PlayerIDs.DRIFT]
	drift_player.stream = drift_sfx
	drift_player.volume_db = -22
	
	crash_player = sfx_players[PlayerIDs.CRASH]
	crash_player.stream = crash_sfx
	
	breakthrough_player = sfx_players[PlayerIDs.BREAKTHROUGH]
	breakthrough_player.stream = breakthrough_sfx


#func _physics_process(_delta):
#	print("\n")
#	print(engine_player.volume_db)
#	print(engine_player.pitch_scale)


func play_audio(state):
	# Match the state to the sample
	match state:
		States.IDLE:
			tween.interpolate_property(
				engine_player,
				"volume_db",
				engine_player.volume_db,
				-20,
				0.6,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
			tween.interpolate_property(
				engine_player,
				"pitch_scale",
				engine_player.pitch_scale,
				0.5,
				0.6,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
			tween.interpolate_property(
				accel_player,
				"volume_db",
				accel_player.volume_db,
				-80,
				0.6,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
			tween.start()
			yield(tween, "tween_all_completed")
			engine_player.volume_db = -20
			engine_player.pitch_scale = 0.5
		States.ACCELERATING:
			accel_player.play()
			tween.interpolate_property(
				engine_player,
				"volume_db",
				engine_player.volume_db,
				-16,
				0.6,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
			tween.interpolate_property(
				engine_player,
				"pitch_scale",
				engine_player.pitch_scale,
				1.5,
				3.0,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
			tween.interpolate_property(
				accel_player,
				"volume_db",
				accel_player.volume_db,
				-8,
				0.6,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
			tween.start()
			yield(tween, "tween_all_completed")
			engine_player.volume_db = -16
			engine_player.pitch_scale = 1.5
		States.DECELERATING:
			accel_player.play()
			tween.interpolate_property(
				engine_player,
				"volume_db",
				engine_player.volume_db,
				-20,
				0.6,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
			tween.interpolate_property(
				engine_player,
				"pitch_scale",
				engine_player.pitch_scale,
				0.5,
				3.0,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
			tween.interpolate_property(
				decel_player,
				"volume_db",
				decel_player.volume_db,
				-8,
				0.6,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
			tween.start()
			yield(tween, "tween_all_completed")
			# TODO - transition to high speed engine noise here
			engine_player.volume_db = -16
			engine_player.pitch_scale = 1.5
		States.CRASH:
			crash_player.play()
			# TODO - add engine stutter to start up
			tween.interpolate_property(
				engine_player,
				"volume_db",
				engine_player.volume_db,
				-70,
				0.3,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
			tween.interpolate_property(
				engine_player,
				"pitch_scale",
				engine_player.pitch_scale,
				0.5,
				0.3,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
			tween.interpolate_property(
				accel_player,
				"volume_db",
				accel_player.volume_db,
				-80,
				0.6,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
			tween.start()
			yield(tween, "tween_all_completed")
			engine_player.volume_db = -20
			engine_player.pitch_scale = 0.5
		States.DRIFTING:
			drift_player.play()
			tween.interpolate_property(
				engine_player,
				"volume_db",
				engine_player.volume_db,
				-20,
				0.7,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
			tween.interpolate_property(
				engine_player,
				"pitch_scale",
				engine_player.pitch_scale,
				0.5,
				0.7,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
			tween.interpolate_property(
				accel_player,
				"volume_db",
				accel_player.volume_db,
				-20,
				0.7,
				Tween.TRANS_SINE,
				Tween.EASE_OUT
			)
			tween.start()


#func transition_walking_sfx(speed):
#	match speed:
#		0:
#			transition_to(States.MOVE_SLOW, 0)
#		1:
#			transition_to(States.MOVE_MEDIUM, 0)
#		2:
#			transition_to(States.MOVE_FAST, 0)


func stop_audio():
	for player in sfx_players:
		if player == engine_player:
			continue
		player.stop()
		player.stream = null


func transition_to(state):
#	stop_audio()
	play_audio(state)
	emit_signal("transitioned", state)
