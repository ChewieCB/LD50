extends Node2D

signal delivered

onready var delivery_zone = $DeliveryZone
onready var is_active = false setget set_active
onready var can_deliver = false setget set_can_deliver


func _ready():
	set_active(is_active)


func _physics_process(_delta):
	if can_deliver:
		if Input.is_action_just_released("interact"):
			emit_signal("delivered")


func set_active(value):
	is_active = value
	
	delivery_zone.visible = is_active


func set_can_deliver(value):
	can_deliver = value
	if can_deliver:
		print("Can deliver to " + self.name)
	else:
		print("Exited " + self.name)


func _on_DeliveryZone_body_entered(body):
	if is_active and body is Player:
		set_can_deliver(true)


func _on_DeliveryZone_body_exited(body):
	if is_active and body is Player:
		set_can_deliver(false)
