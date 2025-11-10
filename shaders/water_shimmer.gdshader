shader_type canvas_item;

// Water Shimmer Shader for Buffalo Brook Gold Rush
// Creates realistic water surface shimmer with animated refractions and highlights
// Optimized for performance

uniform float time_scale : hint_range(0.1, 5.0) = 1.0;
uniform float intensity : hint_range(0.0, 1.0) = 0.3;
uniform float wave_speed : hint_range(0.1, 3.0) = 1.0;
uniform float wave_scale : hint_range(0.1, 2.0) = 0.5;
uniform vec4 shimmer_color : hint_color = vec4(0.8, 0.9, 1.0, 1.0);
uniform float highlight_intensity : hint_range(0.0, 2.0) = 0.8;

void fragment() {
	// Get UV coordinates
	vec2 uv = UV;
	
	// Pre-calculate time and scale values
	float time = TIME * time_scale * wave_speed;
	float scale_factor = wave_scale * intensity;
	
	// Create animated wave patterns using multiple sine/cosine combinations
	// Primary wave movement (simplified)
	float wave1_x = sin(uv.y * 10.0 * wave_scale + time * 0.5) * 0.01 * intensity;
	float wave1_y = cos(uv.x * 8.0 * wave_scale + time * 0.7) * 0.01 * intensity;
	
	// Secondary wave movement (different frequency)
	float wave2_x = cos(uv.x * 15.0 * wave_scale + time * 0.9) * 0.008 * intensity;
	float wave2_y = sin(uv.y * 12.0 * wave_scale + time * 1.1) * 0.008 * intensity;
	
	// Combine all wave displacements
	vec2 displacement = vec2(
		wave1_x + wave2_x,
		wave1_y + wave2_y
	);
	
	// Apply displacement to UVs for refraction effect
	vec2 distorted_uv = uv + displacement;
	
	// Sample the original texture with distortion
	vec4 original_color = texture(TEXTURE, distorted_uv);
	
	// Calculate shimmer effect - simplified version using single noise calculation
	vec2 shimmer_uv = uv * 5.0 * wave_scale + time * 0.2;
	float shimmer_noise = sin(shimmer_uv.x) * cos(shimmer_uv.y);
	shimmer_noise = (shimmer_noise + 1.0) * 0.5; // Remap to [0, 1]
	
	// Add dynamic highlights based on the wave patterns
	vec3 highlight = shimmer_color.rgb * shimmer_noise * highlight_intensity * intensity;
	
	// Combine original color with shimmer effect
	vec3 final_color = original_color.rgb + highlight.rgb;
	
	// Apply the final color with original alpha
	COLOR = vec4(final_color, original_color.a);
}