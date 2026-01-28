shader_type canvas_item;

#include "color_transform.gdshaderinc"

uniform float disabled : hint_range(0.0, 1.0) = 0.0;
uniform vec4[5] original_colors: source_color;
uniform vec4[5] replace_colors: source_color;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 tex = texture(TEXTURE, UV);
    vec4 col = swap_color(tex, original_colors, replace_colors);

	 // Convert to grayscale
    float gray = dot(col.rgb, vec3(0.0, 0.0, 0.0));

    // Blend between normal and grayscale
    col.rgb = mix(col.rgb, vec3(gray), disabled);

	COLOR = col;
}
