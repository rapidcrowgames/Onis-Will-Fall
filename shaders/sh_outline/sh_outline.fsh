//fragment shader
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 texel_size; // 1/largura, 1/altura da textura
uniform vec4 outline_color;
uniform float outline_width;

void main() {
    vec4 base = texture2D(gm_BaseTexture, v_vTexcoord);
    
    if (base.a > 0.0) {
        gl_FragColor = base;
        return;
    }
    
    float alpha = 0.0;
    for (float x = -1.0; x <= 1.0; x++) {
        for (float y = -1.0; y <= 1.0; y++) {
            vec2 offset = vec2(x, y) * texel_size * outline_width;
            alpha += texture2D(gm_BaseTexture, v_vTexcoord + offset).a;
        }
    }
    
    if (alpha > 0.0) {
        gl_FragColor = outline_color;
    } else {
        gl_FragColor = vec4(0.0);
    }
}