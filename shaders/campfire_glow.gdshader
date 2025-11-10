shader_type canvas_item;

// Campfire Glow Shader for Buffalo Brook Gold Rush
// Creates a warm, pulsating glow effect for campfires
// Optimized for performance

uniform float glow_intensity : hint_range(0.0, 2.0) = 0.8;
uniform float glow_radius : hint_range(0.1, 3.0) = 1.5;
uniform float flicker_speed : hint_range(0.1, 5.0) = 2.0;
uniform float color_variation : hint_range(0.0, 1.0) = 0.2;
uniform vec4 base_color : hint_color = vec4(1.0, 0.4, 0.1, 1.0); // Orange-red
uniform vec4 edge_color : hint_color = vec4(0.8, 0.1, 0.0, 0.0); // Darker red at edges

// Simplified distance-based circular glow
float distance_glow(vec2 uv, float radius) {
    float dist = length(uv - vec2(0.5));
    return 1.0 - clamp(dist / radius, 0.0, 1.0);
}

void fragment() {
	// Get UV coordinates
	vec2 uv = UV;
	
	// Calculate center and distance
	vec2 center = vec2(0.5, 0.5);
	float dist = distance(uv, center);
	
	// Calculate base circular glow using simplified distance function
	float base_glow = distance_glow(uv, glow_radius);
	
	// Simplified flickering effect using sine functions only
	float flicker_time = TIME * flicker_speed;
	float flicker = sin(flicker_time) * 0.2 + 0.7; // Base flicker
	flicker += sin(flicker_time * 1.7) * 0.15; // Additional variation
	flicker = clamp(flicker, 0.0, 1.0);
	
	// Apply distance-based falloff
	float glow = base_glow * flicker;
	glow *= (1.0 - pow(dist / glow_radius, 1.2)); // Smooth falloff
	
	// Add simplified color variation for realistic fire colors
	vec3 fire_color = base_color.rgb;
	fire_color.r += sin(TIME * 3.0 + uv.x * 5.0) * color_variation;
	fire_color.g += cos(TIME * 2.5 + uv.y * 4.0) * color_variation * 0.5;
	
	// Create gradient effect from center outward
	float color_gradient = 1.0 - pow(dist / glow_radius, 1.5);
	vec3 gradient_color = mix(edge_color.rgb, fire_color, color_gradient);
	
	// Calculate final glow intensity
	float final_glow = glow * glow_intensity;
	
	// Apply glow only where the original texture has content
	vec4 original_color = texture(TEXTURE, UV);
	float glow_mask = step(0.1, original_color.a); // Only apply glow where alpha > 0.1
	final_glow *= glow_mask;
	
	// Combine original color with glow effect
	vec3 final_color = original_color.rgb + (gradient_color * final_glow);
	
	// Apply final color with original alpha
	COLOR = vec4(final_color, original_color.a);
}