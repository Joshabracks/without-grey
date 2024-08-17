shader_type canvas_item;

uniform bool cyan = true;
uniform bool magenta = true;
uniform bool yellow = true;

uniform float angle: hint_range(0, 1.57079632679) = 0.0; // repeats every PI / 2
uniform float frequency: hint_range(0, 5) = 0.06;
uniform float emboss: hint_range(0.85, 0.95) = 0.85;

const vec4 _cyan = vec4(0.0, 0.678, 0.937, 1.0);
const vec4 _magenta = vec4(0.937, 0.0, 0.545, 1.0);
const vec4 _yellow = vec4(1.0, 0.945, 0.0, 1.0);


void vertex() { // rotate UVs by angle
	UV = VERTEX;
	UV *= mat2(vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle)));
	//UV.x += TIME * 0.001;
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

vec4 color(vec2 uv, float cells) {
	// Called for every pixel the material is visible on.

	if (cyan && magenta && yellow ) {
		float x = mod(uv.x * cells, 2.0);
		float y = mod(uv.y * cells, 2.0);
		return cell_color(uv.x, uv.y, cells);
	} else if (cyan && magenta) {
		return _cyan * _magenta;
		bool cell = mod(floor(uv.x * cells) + floor(uv.y * cells), 2.0) == 0.0;
		return cell ? _cyan : _magenta;
	} else if (cyan && yellow) {
		bool cell = mod(floor(uv.x * cells) + floor(uv.y * cells), 2.0) == 0.0;
		return cell ? _cyan : _yellow;
	} else if (magenta && yellow) {
		bool cell = mod(floor(uv.x * cells) + floor(uv.y * cells), 2.0) == 0.0;
		return cell ? _magenta : _yellow;
	} else if (cyan) {
		bool cell = mod(floor(uv.x * cells) + floor(uv.y * cells), 2.0) == 0.0;
		return cell ? _cyan : _cyan * emboss;
	} else if (magenta) {
		bool cell = mod(floor(uv.x * cells) + floor(uv.y * cells), 2.0) == 0.0;
		return cell ? _magenta : _magenta * emboss;
	} else if (yellow) {
		bool cell = mod(floor(uv.x * cells) + floor(uv.y * cells), 2.0) == 0.0;
		return cell ? _yellow : _yellow * emboss;
	}
}

void fragment() {
	float cells = (TEXTURE_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.x) * frequency; 
	vec4 a = color(vec2(UV.x - 0.5, UV.y), cells);
	vec4 b = color(vec2(UV.x + 0.5, UV.y - 0.5), cells);
	vec4 c = color(vec2(UV.x, UV.y - 0.5), cells);
	COLOR = (a + b + c) / 3.0;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
