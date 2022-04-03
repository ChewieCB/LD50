extends Control

export var time_values = [1.00, 1.50, 2.00]
export var cost_values = [250, 500, 750]

onready var audio_manager = $AudioManager

onready var button_1 = $MarginContainer/CenterContainer/HBoxContainer/CenterContainer/OrganButton1
onready var button_2 = $MarginContainer/CenterContainer/HBoxContainer/CenterContainer2/OrganButton2
onready var button_3 = $MarginContainer/CenterContainer/HBoxContainer/CenterContainer3/OrganButton3

var button_array



func _ready():
	yield(owner, "ready")
	self.visible = false
	
	button_array = [button_1, button_2, button_3]
	for idx in range(button_array.size()):
		var button = button_array[idx]
		
		# Set the time and cost text based on our export vars
		var time_label = button.get_node("VBoxContainer/CenterContainer/Label")
		var cost_label = button.get_node("VBoxContainer/CenterContainer2/Label")
		time_label.text = "+%sm" % str(time_values[idx])
		cost_label.text = "$%s" % str(cost_values[idx])
		
	# Connect each button to the purchase function
	button_1.connect("pressed", self, "purchase_low")
	button_2.connect("pressed", self, "purchase_mid")
	button_3.connect("pressed", self, "purchase_high")
		


func _process(_delta):
	if Input.is_action_just_pressed("shop"):
		if GlobalFlags.IS_PLAYER_CONTROLLABLE:
			toggle_shop()
	
	for idx in range(button_array.size()):
		var button = button_array[idx]
		# Disable the button if we can't afford it
		button.disabled = (MoneyManager.current_money < cost_values[idx])


func toggle_shop():
	self.visible = !self.visible
	get_tree().paused = self.visible


# I hate hardcoding these but it's a jam and I cba sorting passing button IDs to a custom signal 
func purchase_low():
	MoneyManager.current_money -= cost_values[0]
	CountdownTimer._add_time(60 * time_values[0])
	audio_manager.transition_to(audio_manager.States.PURCHASE)
	toggle_shop()

func purchase_mid():
	MoneyManager.current_money -= cost_values[1]
	CountdownTimer._add_time(60 * time_values[1])
	audio_manager.transition_to(audio_manager.States.PURCHASE)
	toggle_shop()

func purchase_high():
	MoneyManager.current_money -= cost_values[2]
	CountdownTimer._add_time(60 * time_values[2])
	audio_manager.transition_to(audio_manager.States.PURCHASE)
	toggle_shop()
