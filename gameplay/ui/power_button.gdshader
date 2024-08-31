shader_type canvas_item;

uniform float offset = 0.0;

void vertex() {
	VERTEX.x = offset + VERTEX.x;
	// Called for every vertex the material is visible on.
}

//void fragment() {
	//vec2 uv = UV;
	//uv.x += offset;
	//COLOR =
//}