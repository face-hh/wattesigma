extends Control

@onready var icon: Sprite2D = $Icon
@onready var label: Label = $Label

func change_to(texture, new_label: String):
	icon.texture = texture
	label.text = new_label
