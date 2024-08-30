shader_type canvas_item;

// Crack generation
uniform float crack_depth : hint_range(0.0, 10.0) = 2.236;
uniform float crack_scale : hint_range(1.0, 10.0) = 4.0;
uniform float crack_zebra_scale : hint_range(0.0, 10.0) = 2.67;
uniform float crack_zebra_amp : hint_range(0.0, 10.0) = 1.3;
uniform float crack_profile : hint_range(0.0, 10.0) = 1.0;
uniform float crack_slope : hint_range(0.0, 50.0) = 45.8;
uniform float crack_width : hint_range(0.0, 1.0) = 0.001;

const vec4 background_color = vec4(0.0, 0.0, 0.0, 0.0);
const vec4 crack_color = vec4(0.0, 0.0, 0.0, 1.0);

// Glass effect
uniform vec2 refraction_offset = vec2(25.0,25.0);
uniform vec2 reflection_offset = vec2(1.0,1.0);
uniform vec4 reflection_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;



vec2 hash(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return fract(sin(p) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    return mix(mix(dot(hash(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0)),
                   dot(hash(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0)), f.x),
               mix(dot(hash(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0)),
                   dot(hash(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0)), f.x), f.y);
}

vec3 voronoi(vec2 u) {
    vec2 p = floor(u);
    vec2 f = fract(u);
    float res = 8.0;
    vec2 b = vec2(0.0);
    for (int j = -1; j <= 1; j++) {
        for (int i = -1; i <= 1; i++) {
            vec2 g = vec2(float(i), float(j));
            vec2 o = hash(p + g);
            vec2 r = g - f + o;
            float d = dot(r, r);
            if (d < res) {
                res = d;
                b = r;
            }
        }
    }
    return vec3(sqrt(res), b);
}

vec3 voronoiB(vec2 u) {
    vec2 p = floor(u);
    vec2 f = fract(u);
    float res = 8.0;
    vec2 C = vec2(0.0);
    vec2 P = vec2(0.0);
    for (int j = -1; j <= 1; j++) {
        for (int i = -1; i <= 1; i++) {
            vec2 g = vec2(float(i), float(j));
            vec2 o = hash(p + g);
            vec2 r = g - f + o;
            float d = dot(r, r);
            if (d < res) {
                res = d;
                C = g;
                P = r;
            }
        }
    }
    res = 8.0;
    for (int j = -2; j <= 2; j++) {
        for (int i = -2; i <= 2; i++) {
            vec2 g = C + vec2(float(i), float(j));
            vec2 o = hash(p + g);
            vec2 r = g - f + o;
            if (dot(P - r, P - r) > 1e-5) {
                res = min(res, 0.5 * dot((P + r), normalize(r - P)));
            }
        }
    }
    return vec3(res, P + f);
}

float fbm(vec2 n) {
    float total = 0.0, amp = 1.0;
    for (int i = 0; i < 7; i++) {
        total += noise(n) * amp;
        n += n;
        amp *= 0.5;
    }
    return total;
}

vec4 generate_cracks(vec2 uv) {
	vec2 U = uv * crack_scale;
    vec2 I = floor(U / 2.0);
    bool vert = mod(I.x + I.y, 2.0) == 0.0;
    vec3 H0;
    vec4 color = background_color;
    for (float i = 0.0; i < crack_depth; i++) {
        vec2 V = U;
        vec2 D = vec2(crack_zebra_amp * fbm(U / crack_zebra_scale) * crack_zebra_scale);
        vec3 H = voronoiB(V + D);
        float d = H.x;
        d = min(1.0, crack_slope * pow(max(0.0, d - crack_width), crack_profile));
        color += vec4(1.0 - d) / exp2(i);
        U *= 1.5;
    }
    color *= crack_color;
	
	return color;
}


void fragment() {	
	COLOR =  generate_cracks(UV);
	vec4 orig_color = COLOR;
	vec4 adjacent_color = generate_cracks(UV + TEXTURE_PIXEL_SIZE * reflection_offset);
	if (adjacent_color.a >= 1.0) {
		COLOR = reflection_color;
	} else {
		COLOR = texture(SCREEN_TEXTURE, SCREEN_UV + COLOR.a*(SCREEN_PIXEL_SIZE * refraction_offset));
	}
}