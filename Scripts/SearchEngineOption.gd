extends OptionButton

func _ready():
	selected = ControlsSingleton.user_data["search_engine"]

func _on_item_selected(index: int) -> void:
	ControlsSingleton.user_data["search_engine"] = index
	ControlsSingleton.save_user_data()
