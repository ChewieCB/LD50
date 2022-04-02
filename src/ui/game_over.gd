extends Control

onready var runtime_label = $CenterContainer/VBoxContainer/CenterContainer2/Label


func _ready():
	yield(owner, "ready")
	self.visible = false
	CountdownTimer.connect("game_over", self, "game_over")


func _process(_delta):
	runtime_label.text = "Run Time: %s" % CountdownTimer.run_elapsed_str

func game_over():
	self.visible = true
