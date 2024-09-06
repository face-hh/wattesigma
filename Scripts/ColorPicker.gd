extends ColorPickerButton

func _ready():
	color = Color.from_string(ControlsSingleton.user_data["color"], Color.BLACK)

func _on_color_changed(color: Color) -> void:
	Utils.change_main_color(color)
