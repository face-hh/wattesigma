extends Node

var google_url = "https://s2.googleusercontent.com/s2/favicons?domain_url={{DOMAIN}}"
@onready var color_overlay: ColorRect = $/root/GUI/BlurOverlay/ColorOverlay
@onready var tabs_overlay: Control = $/root/GUI/TabsOverlay
@onready var search_bar: Control = $/root/GUI/SearchBar

var MAIN_COLOR := Color.BLACK
var search_engine = 0

func fetch_favicon(domain: String) -> ImageTexture:
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	var url = google_url.replace("{{DOMAIN}}", domain.uri_encode())
	var error = http_request.request(url)
	
	if error != OK:
		push_error("An error occurred in the HTTP request.")
		return null
	
	var result = await http_request.request_completed
	
	var response_code = result[1]
	var body = result[3]
	
	if response_code != 200:
		push_warning("Failed to fetch favicon. Attempted fetch at: "+ url + "HTTP response code: " + str(response_code))
		return null
	
	var image = Image.new()
	var error_code = image.load_png_from_buffer(body)
	
	if error_code != OK:
		push_error("Failed to load image from buffer.")
		return null
	
	if image.is_empty():
		push_error("Loaded image is empty.")
		return null
	
	var texture = ImageTexture.create_from_image(image)
	
	if texture.get_size() == Vector2.ZERO:
		push_error("Created texture has zero size.")
		return null
	
	http_request.queue_free()
	
	print("Favicon fetched successfully. Size: ", texture.get_size())
	return texture

func change_main_color(new_color: Color):
	MAIN_COLOR = new_color

	color_overlay.color.r = new_color.r
	color_overlay.color.g = new_color.g
	color_overlay.color.b = new_color.b
	
	search_bar.change_color(new_color)
	tabs_overlay.change_color(new_color)
	
	ControlsSingleton.user_data["color"] = new_color.to_html(false)
	ControlsSingleton.save_user_data()
