shader_type canvas_item;

uniform vec4 base_color: source_color;
uniform float time: hint_range(0, 10);
uniform float intensity = 0.1;

void fragment() {
    float alpha = 0.5 + intensity * sin(TIME * 5.0);
    COLOR = vec4(base_color.rgb, alpha);
}
