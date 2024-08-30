extends Control

@onready var text_edit = $TextEdit

func set_initial_state():
	text_edit.grab_focus()

func _on_text_edit_gui_input(event):
	if !visible: get_viewport().set_input_as_handled()
	
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			goto()
			get_viewport().set_input_as_handled()

func _on_text_edit_text_changed():
	var cursor_line = text_edit.get_caret_line()
	var cursor_column = text_edit.get_caret_column()
	
	var text = text_edit.text
	var lines: PackedStringArray = text.split("\n")
	var new_text = " ".join(lines)
	
	if new_text != text:
		text_edit.text = new_text
		text_edit.set_caret_line(cursor_line)
		text_edit.set_caret_column(cursor_column)

func goto():
	var url = get_url_from_search()
	
	$/root/GUI.current_browser.load_url(url)
	ControlsSingleton.toggle_overlay(self)
	text_edit.clear()

func get_url_from_search() -> String:
	var query = $TextEdit.text.strip_edges()
	
	if query.begins_with("http://") or query.begins_with("https://"):
		return query
	
	var domain_regex = RegEx.new()
	domain_regex.compile("^([a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,}$")
	
	if domain_regex.search(query) or "." in query:
		return "https://" + query
	else:
		var encoded_query = http_escape(query)
		return "https://duckduckgo.com/?q=" + encoded_query

	return ""

func http_escape(input: String) -> String:
	var temp = input.to_utf8_buffer()
	var res = ""
	for i in range(temp.size()):
		var ord = temp[i]
		if ord == 46 or ord == 45 or ord == 95 or ord == 126 or \
		   (ord >= 97 and ord <= 122) or \
		   (ord >= 65 and ord <= 90) or \
		   (ord >= 48 and ord <= 57):
			res += char(ord)
		else:
			res += "%" + ("%02X" % ord)
	return res
