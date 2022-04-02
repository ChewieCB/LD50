extends Character
class_name Player

onready var animation_player = $AnimationPlayer
onready var exhaust_sprite = $ExhaustSprite


func _ready():
	state_machine = $StateMachine
	state_label = $StateLabel
	animation_player.play("idle")
