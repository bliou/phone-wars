shader_type canvas_item;

uniform float speed = 0.15;
uniform float strength = 0.03;

void fragment() {
    vec2 uv = UV;

    // Gentle horizontal wave
    uv.y += sin((uv.x + TIME * speed) * 6.2831) * strength;

    vec4 color = texture(TEXTURE, uv);

    // Tiny brightness modulation
    color.rgb += sin(TIME + uv.y * 10.0) * 0.02;

    COLOR = color;
}