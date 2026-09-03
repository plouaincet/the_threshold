shader_type canvas_item;

void fragment() {
	vec2 uv = UV;
	uv.x = 1.0 - uv.x;
	COLOR = texture(TEXTURE, uv);
}