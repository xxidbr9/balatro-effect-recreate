shader_type canvas_item;

uniform vec2 screen_resolution = vec2(480, 270);
uniform float distortion_size : hint_range(0.0, 10.0) = 1.0; // Controls the size of the distortion

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

void fragment() {
    // Calculate distortion offset based on screen resolution and size parameter
    float offset = distortion_size / screen_resolution.x;

    // Sample each color channel with different UV offsets
    vec2 uv = SCREEN_UV;
    float red = texture(screen_texture, uv - vec2(offset, 0.0)).r;
    float green = texture(screen_texture, uv + vec2(offset, 0.0)).g;
    float blue = texture(screen_texture, uv).b;

    // Combine distorted channels
    COLOR = vec4(red, green, blue, 1.0);
}
