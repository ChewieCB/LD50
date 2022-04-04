extends Node2D

onready var audio_manager = $AudioManager
# These dependency injections always fucking break, structure your code better!!!
onready var pathfinding = $"../Pathfinding"
onready var player = $"../Player"

export (Array, String) var npc_portraits_paths

export var delivery_hub_path := NodePath()
onready var delivery_hub = get_node(delivery_hub_path)

var delivery_points
var current_delivery_point
var current_target

onready var gps_path = []
onready var gps_arrow = $GPSChevron

export var main_ui_path := NodePath()
var main_ui
var npc_dialog


func _ready():
	yield(owner, "ready")
	main_ui = get_node(main_ui_path)
	npc_dialog = main_ui.npc_dialog
	
	delivery_points = get_children()
	delivery_points.erase(audio_manager)
	delivery_points.erase(gps_arrow)
	
	# Connect the delivered signal
	for point in delivery_points:
		point.connect("delivered", self, "delivery_completed")
	
	# Connect the pickup signal
	delivery_hub.connect("pickup", self, "generate_pickup")


#func _draw():
#	if gps_path:
#		for idx in range(gps_path.size()):
#			# Draw every fourth point
#			if idx % 4 != 0:
#				continue
#			var point = gps_path[idx]
#			draw_circle(point, 4, Color(0.7, 0.2, 0.2, 0.5))
#	else:
#		gps_arrow.visible = false


func _process(_delta):
	if current_target:
		# Generate the GPS pathfinding
		gps_path = pathfinding.get_new_path(player.global_position, current_target.global_position)
	update()


func _physics_process(_delta):
	if gps_path:
		gps_arrow.visible = true
		if gps_path.size() > 12:
			gps_arrow.global_position = lerp(gps_arrow.global_position, gps_path[6], 0.2)
			gps_arrow.look_at(gps_path[12])
			gps_arrow.rotate(PI/2)
		else:
			gps_arrow.visible = false
			gps_arrow.global_position = player.global_position
	else:
		gps_arrow.visible = false
		gps_arrow.global_position = player.global_position


func generate_pickup():
	# Pick an organ and delivery stats
	# TODO - add organ specific stuff here
	# Randomise the NPC portrait (and dialog)
	npc_dialog.set_random_dialog()
	npc_dialog.set_random_portrait()
	# Get a delivery point
	activate_new_delivery_point()


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
	
	# Assign a target for the gps
	current_target = current_delivery_point


func delivery_completed(point):
	current_delivery_point.set_can_deliver(false)
	
	current_target = null
	gps_path = []
	
	# Show the NPC dialog
	npc_dialog.show_dialog()
		
	# Generate an amount of money to give the player
	randomize()
	var reward = int(rand_range(30, 80))
	MoneyManager.current_money += reward
	
	# SFX
	audio_manager.transition_to(audio_manager.States.DELIVERY_COMPLETED)
	
#	yield(point.completion_dialog, "timeline_end")
	current_delivery_point.set_active(false)
	
	# Set a new pickup
	delivery_hub.new_delivery()
	current_target = delivery_hub


# NPC randomization
#func randomize_npc_portrait():
#	randomize()
#	var idx = int(rand_range(0, npc_portraits_paths.size()))
#	var path = npc_portraits_paths[idx]
##	DialogicResources.set_theme_value("theme-1649019827.cfg", 'next_indicator','image', path)
#	idx += 1




