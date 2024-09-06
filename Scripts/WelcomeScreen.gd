extends Node2D

func _ready():
	$Control.change_color(Utils.MAIN_COLOR)

func _on_color_picker_button_color_changed(color: Color) -> void:
	Utils.change_main_color(color)
	$Control.change_color(color)

func _on_button_pressed() -> void:
	ControlsSingleton.toggle_input()
	ControlsSingleton.user_data["first_time_opening"] = false
	ControlsSingleton.save_user_data()
