shader_type canvas_item;

#include "pulse.gdshaderinc"
#include "color_transform.gdshaderinc"

uniform vec4[5] original_colors: source_color;
uniform vec4[5] replace_colors: source_color;
uniform vec4 hidden_color: source_color;

uniform float alpha = 1.0;
uniform float pulse_speed = 2.0;
uniform float intensity = 0.8;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
	tex = hide_color(tex, hidden_color);
	tex = swap_color(tex, original_colors, replace_colors);
	tex = pulse(tex, pulse_speed, intensity);

	tex.a *= alpha;
	COLOR = tex;
}
