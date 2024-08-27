extends VBoxContainer

var current_index = 0
var normal_size = Vector2(1, 1)
var active_size = Vector2(1.2, 1.2)
var scroll_speed = 10
var tween_duration = 0.2

func _ready():
	if get_child_count() > 0: set_initial_state()

func set_initial_state():
	for i in range(get_child_count()):
		var child = get_child(i)

		if i != current_index:
			child.scale = normal_size
	
	update_active_element(-1)

func _input(event):
	if !$"../..".visible: return
	
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

func scroll_elements(direction):
	var previous_index = current_index
	current_index = (current_index + direction) % get_child_count()
	
	# scroll start if at end
	if current_index < 0: current_index = get_child_count() - 1
	# if nothing changed, return
	if previous_index == current_index: return
	
	update_active_element(previous_index)

func update_active_element(previous_index):
	var active_child = get_child(current_index)
	
	var previous_child = get_child(previous_index)
	var current_child = get_child(current_index)
	
	var scroll_target = max(0, active_child.position.y - (size.y - active_child.size.y) / 10)
	
	var fade_focus = 0.5;
	
	if current_index == 0: fade_focus = 0.00
	if current_index == 1: fade_focus = 0.25
	
	var texture: GradientTexture2D = $"..".texture
	var gradient = texture.gradient
	
	var tween = create_tween()
	tween.parallel().tween_property(previous_child, "scale", normal_size, tween_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(current_child, "scale", active_size, tween_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "position:y", -scroll_target, tween_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_method(func(val): gradient.set_offset(1, val), gradient.get_offset(1), fade_focus, tween_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
