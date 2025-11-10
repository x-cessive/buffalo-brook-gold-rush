shader_type canvas_item;

// Gold Sparkle Shader for Buffalo Brook Gold Rush
// Creates sparkling effects for gold particles and nuggets
// Optimized for performance

uniform float time_scale : hint_range(0.1, 5.0) = 1.0;
uniform float sparkle_intensity : hint_range(0.0, 2.0) = 0.8;
uniform float sparkle_frequency : hint_range(0.1, 5.0) = 2.0;
uniform float movement_speed : hint_range(0.0, 2.0) = 0.5;
uniform vec4 sparkle_color : hint_color = vec4(1.0, 0.84, 0.0, 1.0); // Gold color
uniform float size_variation : hint_range(0.0, 1.0) = 0.3;
uniform bool animate_sparkles : hint_bool = true;

// Simplified noise function for better performance
float fast_noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
	
    // Simplified noise calculation
    float a = sin(dot(i, vec2(127.1, 311.7)) * 4378.5453);
    float b = sin(dot(i + vec2(1.0, 0.0), vec2(127.1, 311.7)) * 4378.5453);
    float c = sin(dot(i + vec2(0.0, 1.0), vec2(127.1, 311.7)) * 4378.5453);
    float d = sin(dot(i + vec2(1.0, 1.0), vec2(127.1, 311.7)) * 4378.5453);
	
    // Linear interpolation instead of smoothstep for performance
    vec2 u = f;
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

void fragment() {
	// Get UV coordinates
	vec2 uv = UV;
	
	// Calculate time for animation
	float time = animate_sparkles ? TIME * time_scale * movement_speed : 0.0;
	
	// Scale UVs to control sparkle density
	vec2 scaled_uv = uv * 20.0 * sparkle_frequency;
	
	// Create single layer of noise instead of multiple layers
	vec2 sparkle_uv = scaled_uv + vec2(time, -time * 0.7);
	float sparkles = fast_noise(sparkle_uv);
	
	// Enhance the sparkle effect with pow function
	sparkles = pow(max(0.0, sparkles), 2.0) * sparkle_intensity;
	
	// Add temporal variation for more dynamic sparkles
	float temporal_variation = sin(TIME * 8.0) * 0.2 + 0.8;
	sparkles *= temporal_variation;
	
	// Get original texture
	vec4 original_color = texture(TEXTURE, UV);
	
	// Calculate variations in sparkle intensity based on position
	float pos_variation = sin(uv.x * 15.0) * cos(uv.y * 12.0) * size_variation;
	sparkles *= (1.0 + pos_variation);
	
	// Create the sparkle color (gold highlights)
	vec3 sparkle_effect = sparkle_color.rgb * sparkles;
	
	// Add some animation for extra sparkle effect
	vec2 anim_uv = scaled_uv * 0.3 + vec2(TIME * 0.5, TIME * 0.3);
	float anim_sparkle = fast_noise(anim_uv);
	anim_sparkle = pow(max(0.0, anim_sparkle), 3.0) * 1.5;
	sparkle_effect += sparkle_color.rgb * anim_sparkle * sparkle_intensity * 0.3;
	
	// Combine original color with sparkle effect
	vec3 final_color = original_color.rgb + sparkle_effect;
	
	// Apply final color with original alpha (simplified clamping)
	final_color = min(final_color, vec3(1.5));
	
	// Apply final color with original alpha
	COLOR = vec4(final_color, original_color.a);
}