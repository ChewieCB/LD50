extends Control



func _ready():
	self.visible = false


func _process(_delta):
	if Input.is_action_just_pressed("shop"):
		toggle_shop()


func toggle_shop():
	self.visible = !self.visible
	get_tree().paused = self.visible
