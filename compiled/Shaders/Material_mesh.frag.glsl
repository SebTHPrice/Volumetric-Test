#version 450
#include "compiled.inc"
#include "std/gbuffer.glsl"
in vec2 texCoord;
in vec3 wnormal;
out vec4 fragColor[2];

vec3 tex_checker(const vec3 co, const vec3 col1, const vec3 col2, const float scale) {
    // Prevent precision issues on unit coordinates
    vec3 p = (co + 0.000001 * 0.999999) * scale;
    float xi = abs(floor(p.x));
    float yi = abs(floor(p.y));
    float zi = abs(floor(p.z));
    bool check = ((mod(xi, 2.0) == mod(yi, 2.0)) == bool(mod(zi, 2.0)));
    return check ? col1 : col2;
}
float tex_checker_f(const vec3 co, const float scale) {
    vec3 p = (co + 0.000001 * 0.999999) * scale;
    float xi = abs(floor(p.x));
    float yi = abs(floor(p.y));
    float zi = abs(floor(p.z));
    return float((mod(xi, 2.0) == mod(yi, 2.0)) == bool(mod(zi, 2.0)));
}

void main() {
vec3 n = normalize(wnormal);
	vec3 basecol;
	float roughness;
	float metallic;
	float occlusion;
	float specular;
	vec3 TextureCoordinate_UV_res = vec3(texCoord.x, 1.0 - texCoord.y, 0.0);
	vec3 CheckerTexture_Color_res = tex_checker(TextureCoordinate_UV_res, vec3(0.40560463070869446, 0.40560463070869446, 0.40560463070869446), vec3(0.22613081336021423, 0.22613081336021423, 0.22613081336021423), 5.0);
	basecol = CheckerTexture_Color_res;
	roughness = (((CheckerTexture_Color_res.r * 0.3 + CheckerTexture_Color_res.g * 0.59 + CheckerTexture_Color_res.b * 0.11) / 3.0) * 2.5);
	metallic = 0.0;
	occlusion = 1.0;
	specular = 0.0;
	n /= (abs(n.x) + abs(n.y) + abs(n.z));
	n.xy = n.z >= 0.0 ? n.xy : octahedronWrap(n.xy);
	const uint matid = 0;
	fragColor[0] = vec4(n.xy, roughness, packFloatInt16(metallic, matid));
	fragColor[1] = vec4(basecol, packFloat2(occlusion, specular));
}
