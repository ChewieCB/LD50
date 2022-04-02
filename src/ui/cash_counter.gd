extends Control

onready var label = $CashLabel


func _process(_delta):
	label.text = "$" + str(MoneyManager.current_money)

