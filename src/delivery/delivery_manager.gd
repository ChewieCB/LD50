extends Node2D

onready var audio_manager = $AudioManager

export var delivery_hub_path := NodePath()
onready var delivery_hub = get_node(delivery_hub_path)

var delivery_points
var current_delivery_point


func _ready():
	yield(owner, "ready")
	delivery_points = get_children()
	delivery_points.erase(audio_manager)
	
	# Connect the delivered signal
	for point in delivery_points:
		point.connect("delivered", self, "delivery_completed")
	
	# Connect the pickup signal
	delivery_hub.connect("pickup", self, "generate_pickup")


func generate_pickup():
	# Get a delivery point
	activate_new_delivery_point()
	# Pick an organ and delivery stats
	# TODO
	

func activate_new_delivery_point():
	randomize()
	# Ignore current delivery point from new choice
	var eligible_delivery_points = delivery_points.duplicate()
	
	# Remove existing delivery point
	if current_delivery_point:
		eligible_delivery_points.erase(current_delivery_point)
	
	# Pick a random delivery point to activate
	var rand_index = floor(rand_range(0, eligible_delivery_points.size()))
	var new_delivery_point = eligible_delivery_points[rand_index]
	new_delivery_point.set_active(true)
	current_delivery_point = new_delivery_point
	# SFX
	if audio_manager.sfx_player_1.is_playing():
		yield(audio_manager.sfx_player_1, "finished")
	audio_manager.transition_to(audio_manager.States.NEW_DELIVERY)


func delivery_completed(point):
	current_delivery_point.set_can_deliver(false)
		
	# Generate an amount of money to give the player
	randomize()
	var reward = int(rand_range(30, 80))
	MoneyManager.current_money += reward
	
	# SFX
	audio_manager.transition_to(audio_manager.States.DELIVERY_COMPLETED)
	
	yield(point.completion_dialog, "timeline_end")
	current_delivery_point.set_active(false)
	
	# Set a new pickup
	delivery_hub.new_delivery()