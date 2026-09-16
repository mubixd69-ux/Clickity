shader_type canvas_item;

uniform vec4 vigenette_color : source_color = vec4(0.0, 0.0, 0.0, 0.8);
uniform float inner_radius : hint_range(0.0, 1.0) = 0.4;
uniform float outer_radius : hint_range(0.0, 2.0) = 0.9;

void fragment() {
	vec2 uv = UV - vec2(0.5);
	float dist = length(uv);
	float vigenette = smoothstep(inner_radius, outer_radius, dist);
	COLOR = vec4(vigenette_color.rgb, vigenette * vigenette_color.a);
}