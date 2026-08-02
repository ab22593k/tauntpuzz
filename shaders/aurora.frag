#include <flutter/runtime_effect.glsl>

//  A GPU fragment shader used as the app's animated default background.
//
//  • Domain-warped fractal (fbm) noise forms slowly drifting nebula clouds.
//  • A teal→green aurora curtain ripples across the upper sky (a subtle nod
//    to the "leafz" brand).
//  • A two-layer procedural starfield twinkles overhead.
//  • A soft vignette + faint film grain finish the deep-space look.
//
//  Theme-aware: the palette cross-fades between a dark "deep space" look and
//  a bright "day sky" look via uDark (0 = light, 1 = dark), driven from Dart
//  by the app's Brightness.
//
//  Uniforms (set from Dart via FragmentShader.setFloat, in declaration order):
//    index 0,1 : uResolution (vec2)
//    index 2   : uTime       (float, seconds)
//    index 3   : uDark       (float, 0 = light theme, 1 = dark theme)

uniform vec2  uResolution; // 0, 1
uniform float uTime;       // 2
uniform float uDark;       // 3 — 0 = light theme, 1 = dark theme

out vec4 fragColor;

const float PI = 3.14159265359;

//  Hash + value noise
float hash21(vec2 p) {
  p = fract(p * vec2(123.34, 456.21));
  p += dot(p, p + 45.32);
  return fract(p.x * p.y);
}

float vnoise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  vec2 u = f * f * (3.0 - 2.0 * f);
  float a = hash21(i);
  float b = hash21(i + vec2(1.0, 0.0));
  float c = hash21(i + vec2(0.0, 1.0));
  float d = hash21(i + vec2(1.0, 1.0));
  return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Fractal Brownian motion — 5 octaves, rotated each step to hide axis artifacts.
float fbm(vec2 p) {
  float v = 0.0;
  float a = 0.5;
  mat2 rot = mat2(0.8, -0.6, 0.6, 0.8);
  for (int i = 0; i < 5; i++) {
    v += a * vnoise(p);
    p = rot * p * 2.0 + 0.5;
    a *= 0.5;
  }
  return v;
}

//  Procedural starfield — one parallax layer.
//  `density` is the cell-brightness threshold (higher = sparser stars).
float starLayer(vec2 uv, float density, float t) {
  vec2  g = floor(uv);
  float n = hash21(g);
  vec2  f = fract(uv) - 0.5;
  float d = length(f);
  // Twinkle: each star has its own frequency/phase derived from its hash.
  float tw = 0.5 + 0.5 * sin(t * (1.5 + n * 7.0) + n * 30.0);
  // Only the brightest cells become stars.
  float gate = step(density, n);
  float s = smoothstep(0.06, 0.0, d) * ((n - density) / (1.0 - density));
  return s * (0.5 + 0.5 * tw) * gate;
}

void main() {
  vec2 fragCoord = FlutterFragCoord();
  vec2 res = uResolution;
  vec2 uv  = fragCoord / res;
  // Aspect-corrected, centered coordinates; flip so "up" is +y.
  vec2 p = (fragCoord - 0.5 * res) / res.y;
  p.y = -p.y;

  float t = uTime * 0.12; // slow global drift

  // Nebula via domain-warped fbm
  vec2 q = vec2(fbm(p * 1.6 + vec2(0.0, t)),
                fbm(p * 1.6 + vec2(5.2, 1.3) - t));
  vec2 r = vec2(fbm(p * 2.2 + q + vec2(1.7, 9.2) + t * 0.6),
                fbm(p * 2.2 + q + vec2(8.3, 2.8) - t * 0.4));
  float f = fbm(p * 3.0 + r);

  // ---- Theme-aware palette -------------------------------------------
  // Each color is a mix(light, dark, uDark) so the whole scene cross-fades
  // between a bright "day sky" and the dark "deep space" identity.

  // Base: light = near-white → cool grey-blue; dark = near-black → grey-blue.
  vec3 baseLo = mix(vec3(0.95, 0.95, 0.96), vec3(0.03, 0.03, 0.04), uDark);
  vec3 baseHi = mix(vec3(0.90, 0.91, 0.94), vec3(0.06, 0.07, 0.09), uDark);
  vec3 col = mix(baseLo, baseHi, clamp(f * 1.2, 0.0, 1.0));

  // Nebula body tint.
  float neb = smoothstep(0.45, 0.95, f);
  vec3 nebLo = mix(vec3(0.86, 0.88, 0.92), vec3(0.10, 0.12, 0.16), uDark);
  vec3 nebHi = mix(vec3(0.82, 0.85, 0.90), vec3(0.16, 0.20, 0.26), uDark);
  vec3 nebCol = mix(nebLo, nebHi, r.y);
  col = mix(col, nebCol, neb * 0.7);

  // Bright nebula cores (dimmer in light theme — less contrast available).
  vec3 coreCol = mix(vec3(0.70, 0.73, 0.78), vec3(0.55, 0.60, 0.65), uDark);
  float coreAmt = mix(0.35, 0.6, uDark);
  col += coreCol * smoothstep(0.78, 1.0, f) * coreAmt;

  // Aurora curtain (teal → green, the "leafz" accent). Softer/muted in light.
  float ay = p.y + 0.35;
  float band = sin((p.x * 2.0 + r.x * 4.0 + t * 2.0) * PI);
  float curtain = smoothstep(0.0, 0.9, ay) * (0.5 + 0.5 * band);
  // Tear the curtain with noise so it shreds organically.
  curtain *= smoothstep(1.2, 0.2, ay + fbm(p * 4.0 + t) * 0.6);
  vec3 aurLo = mix(vec3(0.55, 0.72, 0.64), vec3(0.15, 0.55, 0.45), uDark);
  vec3 aurHi = mix(vec3(0.40, 0.60, 0.38), vec3(0.35, 0.75, 0.30), uDark);
  vec3 aurCol = mix(aurLo, aurHi, r.x);
  col += aurCol * curtain * mix(0.30, 0.50, uDark);

  // Starfield (two parallax layers). Stars fade out in the light theme
  // (a day sky has no visible stars) and shift from dark specks to white.
  vec2 starUV = uv * vec2(res.x / res.y, 1.0);
  float s1 = starLayer(starUV * 18.0, 0.92, uTime);
  float s2 = starLayer(starUV * 9.0 + 13.7, 0.90, uTime * 0.7);
  vec3 starCol = mix(vec3(0.30, 0.30, 0.34), vec3(0.85, 0.90, 1.0), uDark);
  col += starCol * (s1 + s2 * 0.7) * mix(0.12, 1.0, uDark);

  // Vignette — dark theme darkens the edges; light theme stays flat.
  float vig = smoothstep(1.4, 0.35, length(p));
  col *= mix(1.0, 0.55 + 0.45 * vig, uDark);

  // Faint film grain — stronger in dark theme. Kept subtle so it reads as
  // organic texture rather than shimmering through the frosted puzzle glass.
  col += (hash21(fragCoord + vec2(0.0, uTime)) - 0.5) * mix(0.006, 0.016, uDark);

  fragColor = vec4(col, 1.0);
}
