extends Control

@onready var icon: Sprite2D = $Icon
@onready var label: Label = $Label

func change_to(texture: Texture2D, new_label: String):
	icon.texture = texture
	label.text = new_label
