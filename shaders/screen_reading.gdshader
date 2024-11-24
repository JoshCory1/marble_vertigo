shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, filter_nearest;

void fragment()
{
	vec4 original_color = texture(TEXTURE, UV);
	vec4 screen_color = texture(screen_texture, SCREEN_UV);
	float grayscale = (screen_color.r + screen_color.b + screen_color.g) / 3.0;
	COLOR = vec4(vec3(grayscale), screen_color.a);
}