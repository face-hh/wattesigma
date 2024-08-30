shader_type canvas_item;
uniform sampler2D existing_screen_texture: hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec3 new_color = texture(existing_screen_texture, SCREEN_UV, 0.0).rgb;
	new_color = vec3(1.0) - new_color;
	COLOR.rgb = new_color;
}