shader_type canvas_item;

uniform sampler2D noise_tex : hint_default_white;
uniform vec4 bottom_color : source_color = vec4(0.0, 0.7, 1.0, 1.0);
uniform vec4 middle_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform vec4 top_color : source_color = vec4(1.0, 0.03, 0.001, 1.0);
uniform float fire_alpha : hint_range(0.0, 1.0) = 1.0;
uniform vec2 fire_speed = vec2(0.0, 2.0);
uniform float fire_aperture : hint_range(0.0, 3.0) = 0.22;

vec4 tri_color_mix(vec4 color1, vec4 color2, vec4 color3, float pos) {
    pos = clamp(pos, 0.0, 1.0);
    if (pos < 0.5) {
        return mix(color1, color2, pos * 2.0);
    } else {
        return mix(color2, color3, (pos - 0.5) * 2.0);
    }
}

void fragment() {
    // Scale UVs to make the noise more visible
    vec2 base_uv = UV * 1.0;
    
    // Create two layers of noise with different speeds
    vec2 shifted_uv1 = base_uv + TIME * fire_speed;
    vec2 shifted_uv2 = base_uv + TIME * fire_speed * 1.5;
    
    // Sample noise texture twice
    float fire_noise1 = texture(noise_tex, fract(shifted_uv1)).r;
    float fire_noise2 = texture(noise_tex, fract(shifted_uv2)).r;
    
    // Combine the noise samples
    float combined_noise = (fire_noise1 + fire_noise2) * 0.5;
    
    // Calculate fire shape
    float noise = UV.y * (((UV.y + fire_aperture) * combined_noise - fire_aperture) * 75.0);
    
    // Add horizontal movement
    noise += sin(UV.y * 10.0 + TIME * 2.0) * 0.1;
    
    // Calculate gradient position and mix three colors
    float gradient_pos = clamp(noise * 0.08, 0.3, 2.0);
	//vec4 smoth_mid_color = smoothstep(top_color, middle_color, vec4(1));
    vec4 fire_color = tri_color_mix(bottom_color, middle_color, top_color, gradient_pos);
    
	

    // Set final color and alpha
    COLOR = fire_color;
    COLOR.a = clamp(noise, 0.0, 1.0) * fire_alpha;
}