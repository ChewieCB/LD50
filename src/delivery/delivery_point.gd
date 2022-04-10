extends Node2D

signal delivered(point)

onready var player = $"../../Player"

onready var animation_player = $AnimationPlayer

onready var delivery_zone = $DeliveryZone
onready var is_active = false setget set_active
onready var can_deliver = false setget set_can_deliver

var completion_dialog

func _ready():
	animation_player.play("hidden")
	set_active(is_active)


func _physics_process(_delta):
	if can_deliver:
#		if Input.is_action_just_released("interact"):
		var movement_state = player.state_machine.get_node("Movement")
		if movement_state.velocity.length() < 20:
			generate_delivery_dialog()
			emit_signal("delivered")


func generate_delivery_dialog():
	set_active(false)
	set_can_deliver(false)


func set_active(value):
	is_active = value
	if is_active:
		animation_player.play("fade_in")
		yield(animation_player, "animation_finished")
		animation_player.play("glow")
	else:
#		yield(animation_player, "animation_finished")
		animation_player.play("fade_out")


func set_can_deliver(value):
	can_deliver = value


func _on_DeliveryZone_body_entered(body):
	if is_active and body is Player:
		set_can_deliver(true)
#		generate_delivery_dialog()
#		emit_signal("delivered")


func _on_DeliveryZone_body_exited(body):
	if is_active and body is Player:
		set_can_deliver(false)
