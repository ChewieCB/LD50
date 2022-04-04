extends Control

export (Array, Texture) var npc_portraits
export (int) var current_portrait setget set_current_portait

onready var portrait_rect = $MarginContainer/HBoxContainer/CenterContainer/TextureRect
onready var dialog = $MarginContainer/HBoxContainer/CenterContainer2/Label

var dialogue_data: Dictionary
var current_dialog_text = ""


func _ready():
	yield(owner, "ready")
	# Clear the initial portrait texture
	portrait_rect.texture = null
	self.visible = false
	# Read all the CSV dialogue into a var for retrieving later
	dialogue_data = read_dialogue_data()
	dialog.text = current_dialog_text


func show_dialog():
	self.visible = true


func _process(_delta):
	if Input.is_action_just_pressed("interact") and self.visible:
		self.visible = false


func read_dialogue_data():
	# Store data in a key/value pair of {"organ": ["dialog"]}
	var ouput_data = {
		"Heart": [],
		"Lung": [],
		"Kidney": [],
		"Liver": [],
		"Brain": [],
		"Intestines": [],
		"Eyes": [],
		"Skin": [],
	}
	
	# Read the CSV file
	var data_file = File.new()
	if data_file.open("res://src/delivery/dialog/organ_deliveries.json", File.READ) != OK:
			return
	var data_text = data_file.get_as_text()
	data_file.close()
	var data_parse = JSON.parse(data_text)
	var test0 = data_parse.error
	if data_parse.error != OK:
		return
	var data = data_parse.result
	
	# Extract the JSON data and add it to the output dict
	for key in data:
		# 1 - Heart, 2 - Lung, 3 - Kidney, 4 - Liver, 5 - Brain, 6 - Intestines, 7 - Eyes, 8 - Skin
		var raw_value = data[key]
		# Convert the value from a list of "header":"text" dicts to an Array of dialog text
		var value_arr = []
		for _dict in raw_value:
			value_arr.append(_dict["Text"])
		
		# Add the new dialog data to the data_dict 
		ouput_data[key] += value_arr
	
	return ouput_data


func set_random_portrait():
	var valid_portraits = npc_portraits
	# We don't want to use the same portrait twice
#	valid_portraits.erase(current_portrait)
	
	var rand_idx = int(rand_range(0, valid_portraits.size()))
	set_current_portait(rand_idx)
	print("Using %s as current portrait!" % rand_idx)


func set_random_dialog(organ=null):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var organ_key
	
	if organ:
		# TODO - add organ specific dialogue parsing
		pass
	else:
		var organs =  [
			"Heart", "Lung", "Kidney", "Liver", "Brain", "Intestines", "Eyes", "Skin"
		]
		var rand_idx = rng.randi_range(0, organs.size() - 1)
		organ_key = organs[rand_idx]
	
	# Pick a random dialog text for the specified organ
	var possible_dialog_text = dialogue_data[organ_key]
	
	# Don't repeat the same dialogue twice
	if current_dialog_text and current_dialog_text in possible_dialog_text:
		possible_dialog_text.erase(current_dialog_text)
	
	var rand_idx = rng.randi_range(0, possible_dialog_text.size() - 1)
	var random_dialog = possible_dialog_text[rand_idx]
	
	dialog.text = random_dialog
	
	# Return the organ key for mapping to the ui
	return organ_key


func set_current_portait(value):
	current_portrait = value
	if portrait_rect:
		portrait_rect.texture = npc_portraits[current_portrait]





