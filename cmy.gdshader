shader_type canvas_item;

uniform bool cyan = true;
uniform bool magenta = true;
uniform bool yellow = true;

uniform float angle: hint_range(0, 1.57079632679) = 0.0; // repeats every PI / 2
uniform float frequency: hint_range(0, 0.1) = 0.06;

const vec4 _cyan = vec4(0.0, 0.678, 0.937, 1.0);
const vec4 _magenta = vec4(0.937, 0.0, 0.545, 1.0);
const vec4 _yellow = vec4(1.0, 0.945, 0.0, 1.0);

void vertex() { // rotate UVs by angle
	UV *= mat2(vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle)));
}

vec4 cell_color(float _x, float _y, float cells) {
	float x = mod(floor(_x * cells), 2.0);
	float y = mod(floor(_y * cells), 2.0);
	int xa = x == 0.0 ? 1 : 0;
	int ya = y == 0.0 ? 2 : 0;
	int a = xa + ya;

	if (a == 1 || a == 2) {
		x = mod(_x * cells, 1.0);
		if (x < 0.33) {
			return _yellow;
		}
		if (x < 0.66) {
			return _magenta;
		}
		//if (x < 0.75) {
			return _cyan;
		//}
		//return vec4(1.0);

	} else {
		y = mod(_y * cells, 1.0);
		if (y < 0.33) {
			return _yellow;
		}
		if (y < 0.66) {
			return _magenta;
		}
		//if (y < 0.75) {
			return _cyan;
		//}
		//return vec4(0.0, 0.0, 0.0, 1.0);
	}
	
}

void fragment() {
	// Called for every pixel the material is visible on.
	if (cyan && magenta && yellow ) {
		float cells = (TEXTURE_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.x) * frequency;
		float x = mod(UV.x * cells, 2.0);
		float y = mod(UV.y * cells, 2.0);
		COLOR = cell_color(UV.x, UV.y, cells);
	} else if (cyan && magenta) {
		float cells = TEXTURE_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.x * frequency;
		bool cell = mod(floor(UV.x * cells) + floor(UV.y * cells), 2.0) == 0.0;
		COLOR = cell ? _cyan : _magenta;
	} else if (cyan && yellow) {
		float cells = TEXTURE_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.x * frequency;
		bool cell = mod(floor(UV.x * cells) + floor(UV.y * cells), 2.0) == 0.0;
		COLOR = cell ? _cyan : _yellow;
	} else if (magenta && yellow) {
		float cells = TEXTURE_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.x * frequency;
		bool cell = mod(floor(UV.x * cells) + floor(UV.y * cells), 2.0) == 0.0;
		COLOR = cell ? _magenta : _yellow;
	} else if (cyan) {
		COLOR = _cyan;
	} else if (magenta) {
		COLOR = _magenta;
	} else if (yellow) {
		COLOR = _yellow;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
