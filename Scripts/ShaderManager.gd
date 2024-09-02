extends Node

enum ShaderType {
	SUNLIGHT,
	SCREEN_CRACK,
	FEVER_DREAM,
	RANDOM_ASS_HIGHLIGHT,
	
	BLOCK_CAMERA_MOVEMENT,
	CURSOR_FOLLOW_ON,
	CIRCLE_FOLLOW_ON
}

@onready var sunlight: CanvasLayer = $/root/GUI/CanvasLayer3
@onready var screen_crack: CanvasLayer = $/root/GUI/CanvasLayer2
@onready var fever_dream: ColorRect = $/root/GUI/CanvasLayer/FeverDream
@onready var random_ass_highlight: ColorRect = $/root/GUI/CanvasLayer/RandomAssHighlight

@onready var camera: Camera2D = $/root/GUI/Camera2D

var shader_states = {
	ShaderType.SUNLIGHT: false,
	ShaderType.SCREEN_CRACK: false,
	ShaderType.FEVER_DREAM: false,
	ShaderType.RANDOM_ASS_HIGHLIGHT: false,
	
	ShaderType.BLOCK_CAMERA_MOVEMENT: false,
	ShaderType.CURSOR_FOLLOW_ON: false,
	ShaderType.CIRCLE_FOLLOW_ON: false,
}

func _ready():
	load_shaders()

func set_shader(shader: ShaderType, on: bool):
	shader_states[shader] = on

	match shader:
		ShaderType.SUNLIGHT:
			sunlight.visible = on
		ShaderType.SCREEN_CRACK:
			screen_crack.visible = on
		ShaderType.FEVER_DREAM:
			fever_dream.visible = on
		ShaderType.RANDOM_ASS_HIGHLIGHT:
			random_ass_highlight.visible = on
		
		ShaderType.BLOCK_CAMERA_MOVEMENT:
			camera.block_camera_movement = on
		ShaderType.CURSOR_FOLLOW_ON:
			camera.cursor_follow_on = on
		ShaderType.CIRCLE_FOLLOW_ON:
			camera.circle_follow_on = on
	save_shaders()

func get_shader(shader: ShaderType) -> bool:
	return shader_states[shader]

func save_shaders():
	var save_data = {
		"shader_states": shader_states
	}
	var save_file = FileAccess.open("user://shaders_save.dat", FileAccess.WRITE)
	save_file.store_var(save_data)
	save_file.close()

func load_shaders():
	if FileAccess.file_exists("user://shaders_save.dat"):
		var save_file = FileAccess.open("user://shaders_save.dat", FileAccess.READ)
		var save_data = save_file.get_var()
		save_file.close()
		
		shader_states = save_data["shader_states"]
		
		# Apply loaded states
		for shader in ShaderType.values():
			set_shader(shader, shader_states[shader])
