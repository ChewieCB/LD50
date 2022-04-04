tool
extends Control

export (float) var scroll_rate = 1

onready var scroll_container = $MarginContainer/CenterContainer/TextureRect/MarginContainer/ScrollContainer
onready var ticker_label = $MarginContainer/CenterContainer/TextureRect/MarginContainer/ScrollContainer/Label
onready var ticker_timer = $Timer

var ticker_text = []
var remaining_ticker_text = []
var current_news_item = ""
var current_item_idx = 0


func _ready():
	yield(owner, "ready")
	
	randomize()
	# Read the text data in
	ticker_text = read_ticker_data()
	# Shuffle the order
	ticker_text.shuffle()
	
	scroll_container.get_h_scrollbar().rect_scale.x = 0
	scroll_container.connect("scroll_ended", self, "start_timer")
	
	# Queue up the next item to be shown
	start_timer()


func _process(_delta):
	if scroll_container and current_news_item:
		scroll_container.set_h_scroll(scroll_container.get_h_scroll() + scroll_rate)
		
		if scroll_container.get_h_scrollbar().max_value > 0:
			if scroll_container.get_h_scrollbar().value == scroll_container.get_h_scrollbar().max_value - 236:
				start_timer()


func read_ticker_data():
	# Store data in a key/value pair of {"organ": ["dialog"]}
	var ouput_data = []
	# Read the CSV file
	var data_file = File.new()
	if data_file.open("res://src/ui/news_ticker.json", File.READ) != OK:
			return
	var data_text = data_file.get_as_text()
	data_file.close()
	var data_parse = JSON.parse(data_text)
	var test0 = data_parse.error
	if data_parse.error != OK:
		return
	var data = data_parse.result
	
	return data


func get_next_ticker_item():
	if current_item_idx == ticker_text.size() -1:
		ticker_text.shuffle()
		current_item_idx = 0
	
	current_news_item = ticker_text[current_item_idx]
	current_item_idx += 1


func start_timer():
	# Remove the existing text
	current_news_item = ""
	scroll_container.set_h_scroll(0)
	get_next_ticker_item()


func _on_Timer_timeout():
	var spacing = ""
	for i in range(128):
		spacing += " "
	ticker_label.text = spacing + current_news_item + spacing
	


