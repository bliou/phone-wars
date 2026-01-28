const float precision = 0.1;

vec4 swap_color(vec4 color, vec4[5]original_colors, vec4[5]replace_colors) {
	for (int i = 0; i < 5; i++) {
		if (original_colors[i].a > 0.0 && distance(color, original_colors[i]) <= precision) {
			color = replace_colors[i];
		}
	}

	return color;
}

vec4 hide_color(vec4 color, vec4 hidden_color) {
	if (distance(color, hidden_color) <= precision) {
		color.a = 0.0;
	}

	return color;
}