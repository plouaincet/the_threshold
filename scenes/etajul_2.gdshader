shader_type canvas_item;

uniform sampler2D new_texture;
uniform float blend : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 old_color = texture(TEXTURE, UV);
	vec4 new_color = texture(new_texture, UV);
	COLOR = mix(old_color, new_color, blend);
}