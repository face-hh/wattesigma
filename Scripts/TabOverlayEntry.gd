extends Control

@onready var icon: Sprite2D = $Icon
@onready var label: Label = $Label

var url

func change_to(texture: Variant, new_label: String, new_url: String):
	icon.texture = texture
	label.text = new_label
	url = new_url
