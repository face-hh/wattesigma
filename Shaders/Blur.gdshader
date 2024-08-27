shader_type canvas_item;

uniform vec2 exclude_center; // Center of the area to exclude from blur
uniform vec2 exclude_size;   // Size of the area to exclude from blur
uniform float lod: hint_range(0.0, 5) = 0.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 uv = UV;

    // Check if the current pixel is inside the excluded area
    bool is_inside_exclude_area = 
        uv.x > exclude_center.x - exclude_size.x / 2.0 &&
        uv.x < exclude_center.x + exclude_size.x / 2.0 &&
        uv.y > exclude_center.y - exclude_size.y / 2.0 &&
        uv.y < exclude_center.y + exclude_size.y / 2.0;

    if (is_inside_exclude_area) {
        // If inside the excluded area, just output the original texture
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
    } else {
		vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV, lod);
		COLOR = color;
	}
}