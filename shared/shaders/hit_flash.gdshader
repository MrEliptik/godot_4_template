shader_type spatial;

instance uniform vec4 hit_color: source_color = vec4(1.0);
instance uniform float amount: hint_range(0.0, 1.0, 0.01) = 0.0;

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = hit_color.rgb;
	EMISSION = hit_color.rgb;
	ALPHA = hit_color.a*amount;
}