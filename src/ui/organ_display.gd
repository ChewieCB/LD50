extends Control

export (Array, Texture) var organ_images
export (int) var current_organ setget set_current_organ

onready var organ_image = $CenterContainer/TextureRect
onready var organ_label = $CenterContainer/Label

enum Organs {
	FRAME,
	HEART, KIDNEY, LIVER, LUNG
}

func _ready():
	set_current_organ(Organs.FRAME)


func set_current_organ(value):
	current_organ = value
	
	if organ_image:
		organ_image.texture = organ_images[value]
	
	# Fallback to the name of the organ if we don't have an icon
	if value == Organs.FRAME:
		organ_label.visible = true
	else:
		organ_label.visible = false
		
	


