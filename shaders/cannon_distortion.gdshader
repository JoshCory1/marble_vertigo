shader_type canvas_item;

uniform sampler2D noise_1: repeat_enable;
uniform sampler2D screen_tex: hint_screen_texture, filter_nearest;
uniform sampler2D noise_2: repeat_enable;
uniform float distortipn_strength: hint_range(-1.0, 1.0) = 0.1;
uniform vec2 offset_1 = vec2(0.1);
uniform vec2 offset_2 = vec2(0.2);

void fragment()
{
	vec4 orignel_tex = texture(TEXTURE, UV);
	vec4 noise_color_1 = texture(noise_1, fract(UV + offset_1 * TIME));
	vec4 noise_color_2 = texture(noise_2, fract(UV + offset_2 * TIME));
	
	float final_noise = noise_color_1.r * noise_color_2.r;
	vec4 finel_color = texture(screen_tex,
	 SCREEN_UV + final_noise * distortipn_strength);
	COLOR = finel_color;
	COLOR.a = orignel_tex.a;
}
