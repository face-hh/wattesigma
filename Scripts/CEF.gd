extends Control

# URL
const DEFAULT_PAGE = "user://default_page.html"
const SAVED_PAGE = "user://saved_page.html"
const HOME_PAGE = "https://google.com"
const RADIO_PAGE = "http://streaming.radio.co/s9378c22ee/listen"

# Dictionary to store all browser instances
var browsers = {}
# The current active browser
var current_browser = null
# Counter for generating unique browser IDs
var browser_id_counter = 0
var ignore_new_urls = false;

# Memorize if the mouse was pressed
@onready var mouse_pressed : bool = false
@onready var tabs_overlay = $TabsOverlay

# ==============================================================================
# Create the home page.
# ==============================================================================
func create_default_page():
	var file = FileAccess.open(DEFAULT_PAGE, FileAccess.WRITE)
	file.store_string("<html><head><title>New Tab</title></head><body bgcolor=\"white\"><h2>Welcome to gdCEF !</h2><p>This a generated page.</p></body></html>")
	file.close()
	pass

# ==============================================================================
# Save page as html.
# ==============================================================================
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

# ==============================================================================
# Callback when a page has ended to load with success (200): we print a message
# ==============================================================================
func _on_page_loaded(browser):
	#var L = $Panel/VBox/HBox/BrowserList
	var url = browser.get_url()
# TODO
#	L.set_item_text(L.get_selected_id(), url)
	$Panel/VBox/HBox2/Info.set_text(url + " loaded as ID " + browser.name)
	if !ignore_new_urls:
		tabs_overlay.update_tab(url)
	else:
		ignore_new_urls = false
	#print("Browser named '" + browser.name + "' inserted on list at index " + str(L.get_selected_id()) + ": " + url)

# ==============================================================================
# Callback when a page has ended to load with failure.
# Display a load error message using a data: URI.
# ==============================================================================
func _on_page_failed_loading(aborted, msg_err, node):
	var html = "<html><body bgcolor=\"white\"><h2>Failed to load URL " + node.get_url()
	print_debug(msg_err)
	if aborted:
		html = html + " aborted by the user!</h2></body></html>"
	else:
		html = html + " with error " + msg_err + "!</h2></body></html>"
	node.load_data_uri(html, "text/html")
	pass

# Generate a unique ID for each new browser
func generate_browser_id():
	browser_id_counter += 1
	return str(browser_id_counter)

# ==============================================================================
# Create a new browser and return it or return null if failed.
# ==============================================================================
func create_browser(url):
	ignore_new_urls = true
	# Wait one frame for the texture rect to get its size
	await get_tree().process_frame

	var browser = $CEF.create_browser(url, $Panel/VBox/TextureRect, {"javascript":true, "frame_rate": 120 })
	if browser == null:
		$Panel/VBox/HBox2/Info.set_text($CEF.get_error())
		return null

	# Generate a unique ID for this browser
	var browser_id = generate_browser_id()
	
	# Store the browser in our dictionary
	browsers[browser_id] = browser

	# Loading callbacks
	browser.connect("on_html_content_requested", _on_saving_page)
	browser.connect("on_page_loaded", _on_page_loaded)
	browser.connect("on_page_failed_loading", _on_page_failed_loading)
	
	print("Browser with ID '" + browser_id + "' created with URL " + url)
	tabs_overlay.add_tab(url)

	return browser

# ==============================================================================
# Search the desired by its name. Return the browser as Godot node or null if
# not found.
# ==============================================================================
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

# ==============================================================================
# Remove a browser from the list and close it
# ==============================================================================
func remove_browser(browser_id: String):
	print(browser_id, browsers)
	if browsers.has(browser_id):
		var browser = browsers[browser_id]
		browser.close()
		browsers.erase(browser_id)
		
		if current_browser == browser:
			current_browser = null

		if browsers.size() == 0:
			get_tree().quit()

####
#### Top menu
####

# ==============================================================================
# Create a new browser node. Note: Godot does not show children nodes so you
# will not see created browsers as sub nodes.
# ==============================================================================
func _on_Add_pressed():
	var browser = await create_browser("file://" + ProjectSettings.globalize_path(DEFAULT_PAGE))
	if browser != null:
		current_browser = browser
	pass

# ==============================================================================
# Home button pressed: load a local HTML document.
# ==============================================================================
func _on_Home_pressed():
	if current_browser != null:
		current_browser.load_url(HOME_PAGE)
	else:
		$Panel/VBox/HBox2/Info.set_text("No active browser")
	pass

# ==============================================================================
# Go to the URL given by the text edit widget.
# ==============================================================================
func _on_go_pressed():
	if current_browser != null:
		current_browser.load_url($Panel/VBox/HBox/TextEdit.text)
	else:
		$Panel/VBox/HBox2/Info.set_text("No active browser")
	pass

# ==============================================================================
# Reload the current page
# ==============================================================================
func _on_refresh_pressed():
	if current_browser == null:
		$Panel/VBox/HBox2/Info.set_text("No active browser")
		return
	current_browser.reload()
	pass

# ==============================================================================
# Go to previously visited page
# ==============================================================================
func _on_Prev_pressed():
	if current_browser != null:
		current_browser.previous_page()
	else:
		$Panel/VBox/HBox2/Info.set_text("No active browser")
	pass

# ==============================================================================
# Go to next visited page
# ==============================================================================
func _on_Next_pressed():
	if current_browser != null:
		current_browser.next_page()
	else:
		$Panel/VBox/HBox2/Info.set_text("No active browser")
	pass

# ==============================================================================
# Select the new desired browser from the list of tabs.
# ==============================================================================
func switch_tab(index: int):
	var new_browser = get_browser(str(index + 1))
	
	if current_browser == new_browser: return
	
	current_browser = new_browser
	
	$Panel/VBox/TextureRect.texture = current_browser.get_texture()
	current_browser.resize($Panel/VBox/TextureRect.get_size())

####
#### Bottom menu
####

# ==============================================================================
# Mute/unmute the sound
# ==============================================================================
func _on_mute_pressed():
	if current_browser == null:
		$Panel/VBox/HBox2/Info.set_text("No active browser")
		return
	current_browser.set_muted($Panel/VBox/HBox2/Mute.button_pressed)
	$AudioStreamPlayer2D.stream_paused = $Panel/VBox/HBox2/Mute.button_pressed
	pass

####
#### CEF inputs
####

# ==============================================================================
# Get mouse events and broadcast them to CEF
# ==============================================================================
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

# ==============================================================================
# Make the CEF browser reacts from keyboard events.
# ==============================================================================
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

# ==============================================================================
# Windows has resized
# ==============================================================================
func _on_texture_rect_resized():
	if current_browser == null:
		return
	current_browser.resize($Panel/VBox/TextureRect.get_size())
	$BlurOverlay.size = $Panel.get_size()
	$BlurOverlay/ColorOverlay.size = $Panel.get_size()

####
#### Godot
####

# ==============================================================================
# Create a single browser named "current_browser" that is attached as child node to $CEF.
# ==============================================================================
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

# ==============================================================================
# CEF audio will be routed to this Godot stream object.
# ==============================================================================
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
