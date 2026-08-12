shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float blur_amount : hint_range(0.0, 10.0) = 4.0;

void fragment() {
    vec2 pixel_size = SCREEN_PIXEL_SIZE;
    vec2 uv = SCREEN_UV;

    vec4 color = vec4(0.0);
    float total = 0.0;

    for (int x = -4; x <= 4; x++) {
        for (int y = -4; y <= 4; y++) {
            vec2 offset = vec2(float(x), float(y)) * pixel_size * blur_amount;
            color += texture(SCREEN_TEXTURE, uv + offset);
            total += 1.0;
        }
    }

    COLOR = color / total;
}