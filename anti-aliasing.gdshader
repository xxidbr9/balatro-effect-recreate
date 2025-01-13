shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform vec2 screen_resolution = vec2(480, 270); // Resolution of the screen
uniform float edge_threshold : hint_range(0.0, 1.0) = 0.1; // Threshold for detecting edges
uniform float smoothing_factor : hint_range(0.0, 1.0) = 0.5; // How much to smooth the edges

void fragment() {
    // Calculate pixel size based on screen resolution
    vec2 pixel_size = 1.0 / screen_resolution;

    // Sample the current pixel and its neighbors
    vec4 center_color = texture(screen_texture, SCREEN_UV);
    vec4 left_color = texture(screen_texture, SCREEN_UV - vec2(pixel_size.x, 0.0));
    vec4 right_color = texture(screen_texture, SCREEN_UV + vec2(pixel_size.x, 0.0));
    vec4 top_color = texture(screen_texture, SCREEN_UV - vec2(0.0, pixel_size.y));
    vec4 bottom_color = texture(screen_texture, SCREEN_UV + vec2(0.0, pixel_size.y));

    // Compute luminance (perceived brightness) of each sample
    float center_luminance = dot(center_color.rgb, vec3(0.299, 0.587, 0.114));
    float left_luminance = dot(left_color.rgb, vec3(0.299, 0.587, 0.114));
    float right_luminance = dot(right_color.rgb, vec3(0.299, 0.587, 0.114));
    float top_luminance = dot(top_color.rgb, vec3(0.299, 0.587, 0.114));
    float bottom_luminance = dot(bottom_color.rgb, vec3(0.299, 0.587, 0.114));

    // Calculate edge detection
    float horizontal_edge = abs(left_luminance - right_luminance);
    float vertical_edge = abs(top_luminance - bottom_luminance);
    float edge_strength = max(horizontal_edge, vertical_edge);

    // Determine if the current pixel is part of an edge
    if (edge_strength > edge_threshold) {
        // Blend the pixel with its neighbors to smooth the edge
        vec4 blended_color = (left_color + right_color + top_color + bottom_color) * 0.25;
        COLOR = mix(center_color, blended_color, smoothing_factor);
    } else {
        // If not an edge, output the original color
        COLOR = center_color;
    }
}
