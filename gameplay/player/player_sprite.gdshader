shader_type canvas_item;

uniform int color = 0;
const int cyan = 0;
const int magenta = 1;
const int yellow = 2;

const vec3 _cyan = vec3(0.0, 0.678, 0.937);
const vec3 _magenta = vec3(0.937, 0.0, 0.545);
const vec3 _yellow = vec3(1.0, 0.945, 0.0);
//void vertex() {
	//// Called for every vertex the material is visible on.
//}

void fragment() {
	float alpha = texture(TEXTURE, UV).a;
	if (color == cyan) {
		COLOR = vec4(_cyan, alpha);
	} else if (color == magenta) {
		COLOR = vec4(_magenta, alpha);
	} else if (color == yellow) {
		COLOR = vec4(_yellow, alpha);
	}
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
