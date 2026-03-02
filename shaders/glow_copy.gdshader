shader_type canvas_item;

uniform vec4 neon_color = vec4(0.0, 1.0, 1.0, 1.0);
uniform float glow_radius : hint_range(0.0, 32.0) = 6.0;
uniform float glow_intensity : hint_range(0.0, 4.0) = 1.5;

void fragment() {
	vec2 uv = UV;
	vec4 base = texture(TEXTURE, uv);
	
	// Start with the plain sprite
	vec4 neon = base;
	
	// Only glow where the sprite is
	float alpha = base.a;
	
	// Sample around
	float total = 0.0;
	vec4 glow = vec4(0.0);
	
	// Number of samples (more = smoother but slower)
	const int samples = 8;
	
	for(int i = 0; i < samples; i++) {
		// angle around a circle
		float angle = float(i) / float(samples) * 6.28318;
		vec2 offset = vec2(cos(angle), sin(angle)) * (glow_radius / float(textureSize(TEXTURE,0).x));
		
		vec4 s = texture(TEXTURE, uv + offset);
		// add colored glow
		glow += vec4(neon_color.rgb, s.a) * s.a;
		total += 1.0;
	}
	
	glow /= total; // average
	glow *= glow_intensity;
	
	// Mix glow behind the base sprite
	COLOR = mix(glow, base, base.a);
}