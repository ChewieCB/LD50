extends Control

onready var label = $VBoxContainer/CenterContainer2/CashLabel
onready var reward_label = $VBoxContainer/CenterContainer/RewardLabel
onready var animation_player = $AnimationPlayer


func _ready():
	MoneyManager.connect("reward", self, "show_reward")
	MoneyManager.connect("purchase", self, "subtract_purchase")


func _process(_delta):
	label.text = "$" + str(MoneyManager.current_money)


func show_reward(value):
	# Make the reward amount raise above the players head
	reward_label.text = "+$%s" % value
	animation_player.play("show_reward")


func subtract_purchase(value):
	# Make the reward amount raise above the players head
	reward_label.text = "-$%s" % value
	animation_player.play("show_reward")
