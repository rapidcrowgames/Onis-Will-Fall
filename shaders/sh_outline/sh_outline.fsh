//fragment shader
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 texel_size;
uniform vec4 outline_color;
uniform float outline_width;

void main() {
    vec4 base = texture2D(gm_BaseTexture, v_vTexcoord);
    
    float glow = 0.0;
    float samples = 0.0;
    
    for (float r = 1.0; r <= 3.0; r += 1.0) {
        for (float angle = 0.0; angle < 6.28318; angle += 0.39269) {
            vec2 offset = vec2(cos(angle), sin(angle)) * texel_size * outline_width * r;
            glow += texture2D(gm_BaseTexture, v_vTexcoord + offset).a / r;
            samples += 1.0 / r;
        }
    }
    
    glow /= samples;
    glow = pow(glow, 0.6);
    
    vec4 glowColor = outline_color * glow;
    gl_FragColor = mix(glowColor, base, base.a);
}