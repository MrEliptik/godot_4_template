shader_type canvas_item;
render_mode unshaded;

uniform float circle_size: hint_range(0.0, 1.05);
uniform float screen_width = 1920.0;
uniform float screen_height = 1080.0;
uniform float antialiasing: hint_range(0.0, 1.0, 0.001) = 0.01;

void fragment() {
	float ratio = screen_width / screen_height;
	float dist = distance(vec2(0.5, 0.5), vec2(mix(0.5, UV.x, ratio), UV.y));
	COLOR.a = smoothstep(circle_size-(antialiasing/2.0), circle_size+(antialiasing/2.0), dist);
}