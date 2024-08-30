extends Control

# URL
const DEFAULT_PAGE = "user://default_page.html"
const SAVED_PAGE = "user://saved_page.html"
const HOME_PAGE = "https://google.com"
const RADIO_PAGE = "http://streaming.radio.co/s9378c22ee/listen"

var browsers = {}
var current_browser = null
var browser_id_counter = 0
var ignore_new_urls = false;

var failed_loading_count = 0
var last_failed_loading_time = 0
var is_loading_blocked = false

@onready var mouse_pressed : bool = false
@onready var tabs_overlay = $TabsOverlay

func create_default_page():
	var file = FileAccess.open(DEFAULT_PAGE, FileAccess.WRITE)
	file.store_string("<html><head><title>New Tab</title></head><body bgcolor=\"white\"><h2>Welcome to gdCEF !</h2><p>This a generated page.</p></body></html>")
	file.close()
	pass

func _on_saving_page(html, browser):
	var path = ProjectSettings.globalize_path(SAVED_PAGE)
	var file = FileAccess.open(SAVED_PAGE, FileAccess.WRITE)
	if (file != null):
		file.store_string(html)
		file.close()
		$AcceptDialog.title = browser.get_url()
		$AcceptDialog.dialog_text = "Page saved at:\n" + path
	else:
		$AcceptDialog.title = "Alert!"
		$AcceptDialog.dialog_text = "Failed creating the file " + path
	$AcceptDialog.popup_centered(Vector2(0,0))
	$AcceptDialog.show()
	pass

func _on_page_loaded(browser):
	var url = browser.get_url()
	
	if !ignore_new_urls:
		tabs_overlay.update_tab(url)
	else:
		ignore_new_urls = false

func _on_page_failed_loading(aborted, msg_err, node):
	var current_time = Time.get_ticks_msec()
	
	if current_time - last_failed_loading_time <= 1000:
		failed_loading_count += 1
	else:
		failed_loading_count = 1
	
	last_failed_loading_time = current_time
	
	if failed_loading_count >= 3 and !is_loading_blocked:
		is_loading_blocked = true
		print("Too many failed loading attempts. Loading Google.com...")
		node.load_url(HOME_PAGE)
		
		# Reset the block after a short delay
		await get_tree().create_timer(2.0).timeout
		is_loading_blocked = false
		failed_loading_count = 0
		return
	
	if is_loading_blocked:
		print("Loading blocked. Ignoring request.")
		return
	
	var html = "<html><body bgcolor=\"white\"><h2>Failed to load URL " + node.get_url()
	print_debug(msg_err)
	if aborted:
		html = html + " aborted by the user!</h2></body></html>"
	else:
		html = html + " with error " + msg_err + "!</h2></body></html>"
	node.load_data_uri(html, "text/html")

func generate_browser_id():
	browser_id_counter += 1
	return str(browser_id_counter)

func create_browser(url):
	ignore_new_urls = true
	await get_tree().process_frame

	var browser = $CEF.create_browser(url, $Panel/VBox/TextureRect, {"javascript":true, "frame_rate": 120 })
	if browser == null:
		$Panel/VBox/HBox2/Info.set_text($CEF.get_error())
		return null

	var browser_id = generate_browser_id()
	
	browsers[browser_id] = browser

	# Loading callbacks
	browser.connect("on_html_content_requested", _on_saving_page)
	browser.connect("on_page_loaded", _on_page_loaded)
	browser.connect("on_page_failed_loading", _on_page_failed_loading)
	
	print("Browser with ID '" + browser_id + "' created with URL " + url)
	tabs_overlay.add_tab(url)

	return browser

func get_browser(browser_id):
	if not $CEF.is_alive():
		return null
	if browser_id == null:
		$Panel/VBox/HBox2/Info.set_text("Invalid browser ID: null")
		return null
	var browser = browsers.get(browser_id)
	if browser == null:
		$Panel/VBox/HBox2/Info.set_text("Unknown browser with ID '" + str(browser_id) + "'")
		return null
	return browser

func remove_browser(browser_id: String):
	if browsers.has(browser_id):
		var browser = browsers[browser_id]
		browser.close()
		browsers.erase(browser_id)
		
		if current_browser == browser:
			current_browser = null

		if browsers.size() == 0:
			get_tree().quit()

func switch_tab(index: int):
	var new_browser = get_browser(str(index + 1))
	
	if current_browser == new_browser: return
	
	current_browser = new_browser
	
	$Panel/VBox/TextureRect.texture = current_browser.get_texture()
	current_browser.resize($Panel/VBox/TextureRect.get_size())

func _on_mute_pressed():
	if current_browser == null:
		$Panel/VBox/HBox2/Info.set_text("No active browser")
		return
	current_browser.set_muted($Panel/VBox/HBox2/Mute.button_pressed)
	$AudioStreamPlayer2D.stream_paused = $Panel/VBox/HBox2/Mute.button_pressed
	pass

func _on_TextureRect_gui_input(event):
	if current_browser == null:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			current_browser.set_mouse_wheel_vertical(2)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			current_browser.set_mouse_wheel_vertical(-2)
		elif event.button_index == MOUSE_BUTTON_LEFT:
			mouse_pressed = event.pressed
			if mouse_pressed:
				current_browser.set_mouse_left_down()
			else:
				current_browser.set_mouse_left_up()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			mouse_pressed = event.pressed
			if mouse_pressed:
				current_browser.set_mouse_right_down()
			else:
				current_browser.set_mouse_right_up()
		else:
			mouse_pressed = event.pressed
			if mouse_pressed:
				current_browser.set_mouse_middle_down()
			else:
				current_browser.set_mouse_middle_up()
	elif event is InputEventMouseMotion:
		if mouse_pressed:
			current_browser.set_mouse_left_down()
		current_browser.set_mouse_moved(event.position.x, event.position.y)
	pass

func _input(event):
	if current_browser == null:
		return
	if tabs_overlay.visible: return
	
	for node in get_tree().get_nodes_in_group("gui_input"):
		if node.has_focus():
			return
	
	if event is InputEventKey:
		var key_code = OS.get_keycode_string(event.keycode)
		var is_text = event.unicode != 0 and key_code.length() == 1
		
		if event.is_command_or_control_pressed() and event.pressed and not event.echo:
			if event.keycode == KEY_S:
				# Will call the callback 'on_html_content_requested'
				current_browser.request_html_content()
		
		# Pass all key events, including CTRL, arrow keys, etc.
		current_browser.set_key_pressed(
			event.unicode if is_text else event.keycode,
			event.pressed,
			event.shift_pressed,
			event.alt_pressed,
			event.is_command_or_control_pressed()
		)

func _on_texture_rect_resized():
	print("WINDWO RESIZED!!!!!")
	if current_browser == null:
		return
	current_browser.resize($Panel/VBox/TextureRect.get_size())
	
	var panel_size = $Panel.get_size()
	
	$BlurOverlay.size = panel_size
	$BlurOverlay/ColorOverlay.size = panel_size
	
	var search_bar = $SearchBar
	var search_bar_size = search_bar.get_size()
	
	search_bar.position.x = (panel_size.x - search_bar_size.x) / 2
	search_bar.position.y = (panel_size.y - search_bar_size.y) / 2

func _ready():
	create_default_page()
	
	if !$CEF.initialize({
			"locale":"en-US",
			"enable_media_stream": true,
		}):
		$Panel/VBox/HBox2/Info.set_text($CEF.get_error())
		push_error($CEF.get_error())
		return
	print("CEF version: " + $CEF.get_full_version())

	# Wait one frame for the texture rect to get its size
	current_browser = await create_browser(HOME_PAGE)

func _on_routing_audio_pressed():
	if current_browser == null:
		$Panel/VBox/HBox2/Info.set_text("No active browser")
		return
	if $Panel/VBox/HBox2/RoutingAudio.button_pressed:
		print("You are listening CEF audio routed to Godot and filtered with reverberation effect")
		$AudioStreamPlayer2D.stream = AudioStreamGenerator.new()
		$AudioStreamPlayer2D.stream.set_buffer_length(1)
		$AudioStreamPlayer2D.playing = true
		current_browser.audio_stream = $AudioStreamPlayer2D.get_stream_playback()
	else:
		print("You are listening CEF native audio")
		current_browser.audio_stream = null
		current_browser.set_muted(false)
	$Panel/VBox/HBox2/Mute.button_pressed = false
	# Not necessary, but, I do not know why, to apply the new mode, the user
	# shall click on the html halt button and click on the html button. To avoid
	# this, we reload the page.
	current_browser.reload()

# Add a function to get all browser IDs:
func get_all_browser_ids():
	return browsers.keys()
