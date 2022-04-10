extends Control

onready var runtime_label = $CenterContainer/VBoxContainer/CenterContainer2/Label


func _ready():
	yield(owner, "ready")
	self.visible = false
	CountdownTimer.connect("game_over", self, "game_over")


func _process(_delta):
	runtime_label.text = "Run Time: %s" % CountdownTimer.run_elapsed_str
	
	if self.visible:
		if Input.is_action_just_pressed("reset"):
			GlobalFlags.IS_GAME_OVER = false
			BgmPlayer.game_filtered_to_normal()
			var _ret = get_tree().reload_current_scene()

func game_over():
	self.visible = true
	BgmPlayer.game_ticker_to_filtered()
