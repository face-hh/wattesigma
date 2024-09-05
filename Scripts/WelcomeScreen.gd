extends Node2D

func set_initial_state():
	pass

func _on_color_picker_button_color_changed(color: Color) -> void:
	Utils.change_main_color(color)
