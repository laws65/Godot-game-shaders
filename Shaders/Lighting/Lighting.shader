shader_type canvas_item;

uniform sampler2D light_values;

void fragment() {
	float alpha = 1.0 - texture(light_values, UV).r;
	
	COLOR = vec4(vec3(0.0), alpha);
}