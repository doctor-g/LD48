shader_type canvas_item;

uniform float pulse = 0.0;

void fragment() {
	COLOR = texture(TEXTURE, UV) * abs(cos(pulse * TIME*4.0));
}