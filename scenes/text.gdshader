shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	// Sample the label's glyph texture (this gives us the text shape/alpha)
	vec4 text_sample = texture(TEXTURE, UV);

	// Sample whatever is currently rendered behind this pixel on screen
	vec4 bg_color = texture(screen_texture, SCREEN_UV);

	// Invert the background color (opposite color)
	vec3 inverted = vec3(1.0) - bg_color.rgb;

	// Use the glyph's alpha (so only the actual text shape shows),
	// keep the inverted color as the text's color
	COLOR = vec4(inverted, text_sample.a);
}