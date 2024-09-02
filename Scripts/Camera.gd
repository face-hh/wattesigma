extends Camera2D

var block_camera_movement: bool = true  # Controls if the entire camera system is active
var cursor_follow_on: bool = true  # Controls if the cursor-following behavior is active
var circle_follow_on: bool = true  # Controls if the circular motion is active

var radius = 5.0  # Radius for circular motion
var angular_speed = 1.0  # Speed of rotation
var angle = 0.0  # Current angle of rotation
var inactivity_timer = 0.0  # Timer to track cursor inactivity
var inactivity_threshold = 1.0  # Time in seconds before starting circular motion
var last_cursor_position = Vector2.ZERO  # To detect cursor movement
var follow_strength = 0.010  # How strongly the camera follows the cursor (0.0 to 1.0)
var initial_rect_position: Vector2
var initial_rect_size: Vector2

func _ready():
	last_cursor_position = get_global_mouse_position()
	var color_rect = $"../CanvasLayer3/ColorRect2"
	initial_rect_position = color_rect.position
	initial_rect_size = color_rect.size

func _process(delta):
	if block_camera_movement:
		return  # If the entire camera system is off, do nothing

	var color_rect = $"../CanvasLayer3/ColorRect2"
	var base_position = initial_rect_position + (color_rect.size - initial_rect_size) / 2
	var cursor_position = get_global_mouse_position()
	
	if cursor_follow_on:
		if cursor_position != last_cursor_position:
			# Cursor is moving
			inactivity_timer = 0.0
			var cursor_offset = (cursor_position - base_position) * follow_strength
			position = base_position + cursor_offset
		else:
			# Cursor is not moving
			inactivity_timer += delta
			if inactivity_timer >= inactivity_threshold:
				# Perform circular motion if circle_camera_on is true
				if circle_follow_on:
					angle += angular_speed * delta
					var circular_offset = Vector2(cos(angle), sin(angle)) * radius
					position = base_position + circular_offset
			else:
				# Gradually return to base position
				position = position.lerp(base_position, delta * 2)
	else:
		# If cursor_camera_on is false, reset to base position
		position = base_position
	
	# Always update the circular motion if circle_camera_on is true
	if circle_follow_on:
		angle += angular_speed * delta
		var circular_offset = Vector2(cos(angle), sin(angle)) * radius
		position += circular_offset
	
	last_cursor_position = cursor_position
