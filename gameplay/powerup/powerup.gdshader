shader_type canvas_item;

uniform sampler2D noise : repeat_enable; 
uniform sampler2D noise2 : repeat_enable;  
uniform float time_scale = 1.0;
uniform int color = 0;
uniform float collect_timer = 0.0;

const vec4 _cyan = vec4(0.0, 0.678, 0.937, 1.0);
const vec4 _magenta = vec4(0.937, 0.0, 0.545, 1.0);
const vec4 _yellow = vec4(1.0, 0.945, 0.0, 1.0);

void fragment() {
	vec2 cc_uv = UV - vec2(.5); 
	float angle = atan(cc_uv.y, cc_uv.x) / PI + 1.;
	float p = sqrt(dot(cc_uv, cc_uv)); 
	vec2 puv = vec2(p, angle * .5);
	vec2 uv = puv * 2.;
	float time = TIME * time_scale;
	vec4 old_colo = color == 0 ? _cyan : (color == 1 ? _magenta : _yellow);
	COLOR = vec4(.0);
	for(int i = 1; i <= 5; i++){
		float intensive = .1 + .07 * float(i);
		vec2 offset = (texture(noise, vec2(time*.35*(.5+fract(sin(float(i)*55.))), angle)).rg - vec2(.5)) * intensive; 
		vec2 uuv = uv + offset;
		float dist = abs(uuv.x - .5);
		float rand_speed = .2 + .05 * fract(cos(float(i)*1144.));
		float gone = smoothstep(.1 + 0.05 * (float(i) - .5), 1.0, texture(noise2, uv + vec2(time*rand_speed)).s);
		COLOR += gone * old_colo / dist * .01 * texture(noise2, uuv + vec2(time)).s;
	}
	vec4 light = old_colo * smoothstep(1.0, -2.0, abs(uv.x - .5) * 2.0) * texture(noise2, uv).a;
	COLOR += light;
	float shrink = abs(collect_timer - UV.x);
	COLOR *= shrink;
	COLOR = COLOR.a > 0.15 ? old_colo : vec4(0, 0, 0, 0);
}
 