extends Control

export var time_values = [1.00, 2.00, 3.00, "inf"]
export var cost_values = [150, 270, 500, 10_000]

onready var audio_manager = $AudioManager

onready var button_1 = $MarginContainer/CenterContainer/HBoxContainer/CenterContainer/VBoxContainer/OrganButton1
onready var button_2 = $MarginContainer/CenterContainer/HBoxContainer/CenterContainer2/VBoxContainer/OrganButton2
onready var button_3 = $MarginContainer/CenterContainer/HBoxContainer/CenterContainer3/VBoxContainer/OrganButton3
onready var button_4 = $MarginContainer/CenterContainer/HBoxContainer/CenterContainer4/VBoxContainer/OrganButton4

var button_array



func _ready():
	yield(owner, "ready")
	self.visible = false
	
	button_array = [button_1, button_2, button_3, button_4]
	for idx in range(button_array.size()):
		var button = button_array[idx]
		
		# Set the time and cost text based on our export vars
		var time_label = button.get_node("VBoxContainer/CenterContainer/Label")
		var cost_label = button.get_node("VBoxContainer/CenterContainer2/Label")
		# Edge case for final purchase
		if idx == 3:
			time_label.text = "+%s" % str(time_values[idx])
			var cost_string = str(cost_values[idx])
			var split_cost = [cost_string.substr(0, 2), cost_string.substr(2,5)]
			cost_label.text = "$%s,%s" % [split_cost[0], split_cost[1]]
		else:
			time_label.text = "+%sm" % str(time_values[idx])
			cost_label.text = "$%s" % str(cost_values[idx])


func _physics_process(_delta):
	if Input.is_action_just_pressed("interact") and GlobalFlags.CAN_SHOP:
		if GlobalFlags.IS_PLAYER_CONTROLLABLE:
			toggle_shop()
	
	for idx in range(button_array.size()):
		var button = button_array[idx]
		# Disable the button if we can't afford it
		button.disabled = (MoneyManager.current_money < cost_values[idx])
	
	if self.visible:
		if Input.is_action_just_pressed("shop_key_1"):
			if not button_1.disabled:
				purchase_low()
		elif Input.is_action_just_pressed("shop_key_2"):
			if not button_2.disabled:
				purchase_mid()
		elif Input.is_action_just_pressed("shop_key_3"):
			if not button_3.disabled:
				purchase_high()


func toggle_shop():
	self.visible = !self.visible
	get_tree().paused = self.visible


# I hate hardcoding these but it's a jam and I cba sorting passing button IDs to a custom signal 
func purchase_low():
	MoneyManager.current_money -= cost_values[0]
	CountdownTimer._add_time(60 * time_values[0])
	button_1.set_pressed(true)
	audio_manager.transition_to(audio_manager.States.PURCHASE)
	yield(get_tree().create_timer(0.3), "timeout")
	toggle_shop()
	button_1.set_pressed(false)

func purchase_mid():
	MoneyManager.current_money -= cost_values[1]
	CountdownTimer._add_time(60 * time_values[1])
	button_2.set_pressed(true)
	audio_manager.transition_to(audio_manager.States.PURCHASE)
	yield(get_tree().create_timer(0.3), "timeout")
	toggle_shop()
	button_2.set_pressed(false)

func purchase_high():
	MoneyManager.current_money -= cost_values[2]
	CountdownTimer._add_time(60 * time_values[2])
	button_3.set_pressed(true)
	audio_manager.transition_to(audio_manager.States.PURCHASE)
	yield(get_tree().create_timer(0.3), "timeout")
	toggle_shop()
	button_3.set_pressed(false)
