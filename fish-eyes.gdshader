shader_type canvas_item;

uniform vec2 screen_resolution = vec2(480, 270);
uniform float fisheye_intensity : hint_range(0.0, 1.0) = 0.0; // 0: No distortion, 1: Full fish-eye

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

void fragment() {
    // Normalize screen coordinates to [-1, 1]
    vec2 uv = SCREEN_UV * 2.0 - 1.0;

    // Apply fish-eye distortion
    float radius = length(uv);
    if (fisheye_intensity > 0.0) {
        float distortion = mix(1.0, 1.0 + radius * radius, fisheye_intensity);
        uv *= distortion;
    }

    // Convert back to [0, 1] range
    uv = uv * 0.5 + 0.5;


    // Check if UV is outside valid range
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0); // Black color for out-of-bounds
    } else {
        // Blend pixel with left and top pixel to simulate color bleeding
        vec4 adjacent_pixel_color_average = texture(screen_texture, uv - vec2(1.0 / screen_resolution.x, 0)) * 0.5 +
                                            texture(screen_texture, uv - vec2(0, 1.0 / screen_resolution.y)) * 0.5;

        COLOR = adjacent_pixel_color_average;
    }
}
