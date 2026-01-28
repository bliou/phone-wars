vec4 pulse(vec4 tex, float pulse_speed, float intensity) {
	float pulse = sin(TIME * pulse_speed) * 0.5 + 0.5;
	tex.rgb *= 1.0 + pulse * intensity;
	
	return tex;
}