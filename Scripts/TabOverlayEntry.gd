extends Control

@onready var icon: Sprite2D = $Icon
@onready var label: Label = $Label
@onready var color_rect: ColorRect = $ColorRect

var url

func _ready():
	change_color(Utils.get_main_color())

func change_to(texture: Variant, new_label: String, new_url: String):
	icon.texture = texture
	label.text = new_label
	url = new_url

func change_color(new_color: Color):
	color_rect.color = new_color
