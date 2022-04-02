extends Character
class_name Player

onready var animation_player = $AnimationPlayer
onready var exhaust_sprite = $ExhaustSprite
onready var reward = $Control/RewardLabel


func _ready():
	state_machine = $StateMachine
	state_label = $StateLabel
	animation_player.play("idle")
	
	CountdownTimer.run_start_time = OS.get_unix_time()
	GlobalFlags.IS_PLAYER_CONTROLLABLE = true
