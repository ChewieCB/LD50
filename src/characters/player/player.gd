extends Character
class_name Player

onready var animation_player = $AnimationPlayer
onready var audio_manager = $AudioManager
onready var exhaust_sprite = $ExhaustSprite
onready var reward = $Control/RewardLabel


func _ready():
	state_machine = $StateMachine
	state_label = $StateLabel
	animation_player.play("idle")
	
	CountdownTimer.connect("game_over", self, "death")
	
	CountdownTimer.run_start_time = OS.get_unix_time()
	GlobalFlags.IS_PLAYER_CONTROLLABLE = true


func death():
	state_machine.transition_to("Movement/Death")

