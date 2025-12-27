// Outline pixels near a chosen color
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D u_tex;
uniform vec3 u_targetColor;
uniform vec3 u_outlineColor;
uniform float u_threshold;
uniform vec2 u_texelSize;

uniform float u_softness;
uniform float u_edgeScale;

varying vec4 vertTexCoord;

float maskAt(vec2 offset) {
	vec3 c = texture2D(u_tex, vertTexCoord.st + offset * u_texelSize).rgb;
	float distToTarget = distance(c, u_targetColor);
	float luminance = dot(c, vec3(0.299, 0.587, 0.114));
	float targetLuminance = dot(u_targetColor, vec3(0.299, 0.587, 0.114));
	float lumDiff = abs(luminance - targetLuminance);
	// Combine color and luminance for smarter mask
	float colorMask = 1.0 - smoothstep(u_threshold, u_threshold + u_softness, distToTarget);
	float lumMask = 1.0 - smoothstep(u_threshold, u_threshold + u_softness, lumDiff);
	// Use both masks, but require both to be high (AND)
	return colorMask * lumMask;
}

void main() {
	vec3 base = texture2D(u_tex, vertTexCoord.st).rgb;

	// 3x3 Gaussian blur of the mask
	float blur = 0.0;
	blur += maskAt(vec2(-1.0, -1.0)) * 1.0;
	blur += maskAt(vec2(0.0, -1.0)) * 2.0;
	blur += maskAt(vec2(1.0, -1.0)) * 1.0;
	blur += maskAt(vec2(-1.0, 0.0)) * 2.0;
	blur += maskAt(vec2(0.0, 0.0)) * 4.0;
	blur += maskAt(vec2(1.0, 0.0)) * 2.0;
	blur += maskAt(vec2(-1.0, 1.0)) * 1.0;
	blur += maskAt(vec2(0.0, 1.0)) * 2.0;
	blur += maskAt(vec2(1.0, 1.0)) * 1.0;
	blur /= 16.0;

	// Sobel edge detection on blurred mask
	float gx = 0.0;
	gx += maskAt(vec2(-1.0, -1.0)) * -1.0;
	gx += maskAt(vec2(0.0, -1.0)) * -2.0;
	gx += maskAt(vec2(1.0, -1.0)) * -1.0;
	gx += maskAt(vec2(-1.0, 1.0)) * 1.0;
	gx += maskAt(vec2(0.0, 1.0)) * 2.0;
	gx += maskAt(vec2(1.0, 1.0)) * 1.0;

	float gy = 0.0;
	gy += maskAt(vec2(-1.0, -1.0)) * -1.0;
	gy += maskAt(vec2(-1.0, 0.0)) * -2.0;
	gy += maskAt(vec2(-1.0, 1.0)) * -1.0;
	gy += maskAt(vec2(1.0, -1.0)) * 1.0;
	gy += maskAt(vec2(1.0, 0.0)) * 2.0;
	gy += maskAt(vec2(1.0, 1.0)) * 1.0;

	float edge = clamp(length(vec2(gx, gy)) * u_edgeScale, 0.0, 1.0);
	vec3 finalColor = mix(base, u_outlineColor, edge);

	gl_FragColor = vec4(finalColor, 1.0);
}
