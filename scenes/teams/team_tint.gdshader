shader_type canvas_item;

uniform float disabled : hint_range(0.0, 1.0) = 0.0;

uniform vec4 original_color : source_color;

uniform vec4 replace_color : source_color;

const float precision = 0.1;

vec4 swap_color(vec4 color) {
	if (distance(color, original_color) <= precision) {
		color = replace_color;
	}

	return color;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 tex = texture(TEXTURE, UV);
    vec4 col = swap_color(tex);

	 // Convert to grayscale
    float gray = dot(col.rgb, vec3(0.0, 0.0, 0.0));

    // Blend between normal and grayscale
    col.rgb = mix(col.rgb, vec3(gray), disabled);

	COLOR = col;
}
