shader_type canvas_item;

uniform vec4 hit_color : source_color = vec4(1., 1., 1., 1.);
uniform vec4 hit_color_mirror : source_color = vec4(1., 0., 0., 1.);
uniform bool mirror = false;
uniform bool enabled = false;

void fragment() {
	if (enabled) {
		if (mirror) {
			COLOR.rgb = hit_color_mirror.rgb;
		} else {
			COLOR.rgb = hit_color.rgb;
		}
	}
}
