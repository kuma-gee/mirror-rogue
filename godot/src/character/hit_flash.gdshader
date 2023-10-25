shader_type canvas_item;

uniform vec4 hit_color : source_color = vec4(1., 0., 0., 1.);
uniform bool enabled = false;

void fragment() {
	if (enabled) {
		COLOR.rgb = hit_color.rgb;
	}
}
