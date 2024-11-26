shader_type canvas_item;

uniform float dissolve_pct: hint_range(0.0, 1.0) = 0.0f;
uniform sampler2D noise_tex;

void fragment()
{
	vec4 original_color = texture(TEXTURE, UV);
	vec4 final_color = original_color;
	
	vec4 noise = texture(noise_tex, UV);
	
	if(dissolve_pct >= noise.r)
	{
		final_color.a = 0.0f;
	}
	
	COLOR = final_color;
}