extends Control

var current_index = 0
var normal_size = Vector2(1, 1)
var active_size = Vector2(1.2, 1.2)
var scroll_speed = 10
var tween_duration = 0.2

@onready var container: VBoxContainer = $TextureRect/VBoxContainer
const TABS_OVERLAY_ENTRY = preload("res://Scenes/TabsOverlayEntry.tscn")
const DEFAULT_TEXTURES = preload("res://default_tab.png")

func _ready():
	if container.get_child_count() > 0: set_initial_state()

func change_color(new_color: Color):
	for node in container.get_children():
		node.change_color(new_color)

func set_initial_state():
	for i in range(container.get_child_count()):
		var child = container.get_child(i)
		if i != current_index:
			child.scale = normal_size
	
	update_active_element(-1)

func _input(event):
	if !visible: return
	
	# ==== KEYBOARD ====
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_DOWN:
			scroll_elements(1)
		elif event.keycode == KEY_UP:
			scroll_elements(-1)
	# ====  MOUSE  ====
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			scroll_elements(1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			scroll_elements(-1)
	# # ==== SHORTCUTS ====
	if Input.is_action_just_pressed("tab_close"):
		close_tab()
		$/root/GUI.remove_browser(str(current_index + 1))

func scroll_elements(direction):
	var previous_index = current_index
	current_index = (current_index + direction) % container.get_child_count()
	
	# scroll start if at end
	if current_index < 0: current_index = container.get_child_count() - 1
	# if nothing changed, return
	if previous_index == current_index: return
	
	update_active_element(previous_index)

func update_active_element(previous_index):
	var active_child = container.get_child(current_index)
	
	var previous_child = container.get_child(previous_index)
	var current_child = container.get_child(current_index)
	
	var scroll_target = max(0, active_child.position.y - (container.size.y - active_child.size.y) / 10)
	
	var fade_focus = 0.5;
	
	if current_index == 0: fade_focus = 0.00
	if current_index == 1: fade_focus = 0.25
	
	var texture: GradientTexture2D = $TextureRect.texture
	var gradient = texture.gradient
	
	var tween = create_tween()
	tween.parallel().tween_property(previous_child, "scale", normal_size, tween_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(current_child, "scale", active_size, tween_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property($TextureRect/VBoxContainer, "position:y", -scroll_target, tween_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_method(func(val): gradient.set_offset(1, val), gradient.get_offset(1), fade_focus, tween_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	$/root/GUI.switch_tab(current_index)

func add_tab(url):
	var node = TABS_OVERLAY_ENTRY.instantiate()
	var favicon = await Utils.fetch_favicon(url)
	
	container.add_child(node)
	
	var title = await $/root/GUI.current_browser.get_title()
	node.change_to(favicon if favicon else DEFAULT_TEXTURES, title if title else "New Tab", url)

func update_tab(url):
	var node = container.get_child(current_index)
	if !node:
		return
	if node.url == url:
		return
	
	var favicon = await Utils.fetch_favicon(url)
	
	var title = await $/root/GUI.current_browser.get_title()
	print(title)
	node.change_to(favicon if favicon else DEFAULT_TEXTURES, title if title else "New Tab", url)

func close_tab():
	var child_count = container.get_child_count()
	
	if child_count == 0:
		return
	
	var tab = container.get_child(current_index)
	
	tab.queue_free()
	await tab.tree_exited
	
	if child_count == 1:
		current_index = -1
	elif current_index == child_count - 1:
		current_index = child_count - 2
	
	if current_index >= 0:
		set_initial_state()
