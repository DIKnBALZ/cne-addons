#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
vec2 iMouse;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

void main() {
	vec2 coordinates = fragCoord.xy/iResolution.xy;
	const float size = 6.0;
	vec2 pixelSize = vec2(size/iResolution.x, size/iResolution.y);
	vec2 position = floor(coordinates/pixelSize)*pixelSize;
	vec4 finalColor = texture(iChannel0, position);
	fragColor = finalColor;
}