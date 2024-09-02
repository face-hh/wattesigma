extends Node2D

# note: i fucking hate myself for making enums this long. this is unreadable

@onready var checkbuttons: Array[CheckButton] = [
	$Sunlight/CheckButton,
	$FeverDream/CheckButton,
	$RandomAhhHighlighter/CheckButton,
	$FeverDream3/CheckButton
]

@onready var checkboxes: Array[CheckBox] = [
	$Cursor/Entirely/CheckBox,
	$Cursor/CursorFollow/CheckBox2,
	$Cursor/CircleFollow/CheckBox3
]

func _ready():
	set_initial_state()

func set_initial_state():
	var shader_types = [
		ShaderManager.ShaderType.SUNLIGHT,
		ShaderManager.ShaderType.FEVER_DREAM,
		ShaderManager.ShaderType.RANDOM_ASS_HIGHLIGHT,
		ShaderManager.ShaderType.SCREEN_CRACK,
		ShaderManager.ShaderType.BLOCK_CAMERA_MOVEMENT,
		ShaderManager.ShaderType.CURSOR_FOLLOW_ON,
		ShaderManager.ShaderType.CIRCLE_FOLLOW_ON
	]
	
	for i in range(checkbuttons.size()):
		checkbuttons[i].button_pressed = ShaderManager.get_shader(shader_types[i])
	
	for i in range(checkboxes.size()):
		checkboxes[i].button_pressed = ShaderManager.get_shader(shader_types[i + 4])

func _on_shader_toggled(shader_type: ShaderManager.ShaderType, toggled_on: bool):
	ShaderManager.set_shader(shader_type, toggled_on)
	
	if shader_type == ShaderManager.ShaderType.BLOCK_CAMERA_MOVEMENT:
		if toggled_on:
			disable_cursor_and_circle()

	elif shader_type in [ShaderManager.ShaderType.CURSOR_FOLLOW_ON, ShaderManager.ShaderType.CIRCLE_FOLLOW_ON]:
		if toggled_on:
			disable_block_camera()

func disable_cursor_and_circle():
	ShaderManager.set_shader(ShaderManager.ShaderType.CURSOR_FOLLOW_ON, false)
	ShaderManager.set_shader(ShaderManager.ShaderType.CIRCLE_FOLLOW_ON, false)
	checkboxes[1].button_pressed = false
	checkboxes[2].button_pressed = false

func disable_block_camera():
	ShaderManager.set_shader(ShaderManager.ShaderType.BLOCK_CAMERA_MOVEMENT, false)
	checkboxes[0].button_pressed = false

func _on_sunlight(toggled_on): _on_shader_toggled(ShaderManager.ShaderType.SUNLIGHT, toggled_on)
func _on_fever_dream(toggled_on): _on_shader_toggled(ShaderManager.ShaderType.FEVER_DREAM, toggled_on)
func _on_highlighter(toggled_on): _on_shader_toggled(ShaderManager.ShaderType.RANDOM_ASS_HIGHLIGHT, toggled_on)
func _on_crack(toggled_on): _on_shader_toggled(ShaderManager.ShaderType.SCREEN_CRACK, toggled_on)
func _on_entire_camera(toggled_on): _on_shader_toggled(ShaderManager.ShaderType.BLOCK_CAMERA_MOVEMENT, toggled_on)
func _on_cursor(toggled_on): _on_shader_toggled(ShaderManager.ShaderType.CURSOR_FOLLOW_ON, toggled_on)
func _on_circle(toggled_on): _on_shader_toggled(ShaderManager.ShaderType.CIRCLE_FOLLOW_ON, toggled_on)
