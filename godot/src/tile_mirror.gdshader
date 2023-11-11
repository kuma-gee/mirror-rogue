shader_type canvas_item;

uniform sampler2D reflection_viewport;

uniform vec4 base_color : source_color = vec4(.5, .5, .5, 1.);
uniform vec4 shine_color : source_color = vec4(1.0);
uniform float shine_speed : hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float shine_size : hint_range(0.01, 1.0, 0.01) = 0.01;

float scale(float value, float inMin, float inMax, float outMin, float outMax) {
    return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
}

void fragment() {
	vec4 color = COLOR;
	
	if (color == vec4(1.0)) {
		color = base_color;
		float shine = step(1.0 - shine_size * 0.01, 0.5 + 0.5 * sin(SCREEN_UV.x - SCREEN_UV.y + TIME * shine_speed));
		color.rgb = mix(color.rgb, shine_color.rgb, shine * shine_color.a);
		
		vec4 reflection = texture(reflection_viewport, SCREEN_UV);
		color.rgb = color.rgb * (1.0 - reflection.a) + reflection.rgb * reflection.a;
	}
	
	COLOR = color;
}
