varying vec2 v_vTexcoord;

uniform vec2 u_texel;      // 1/largura, 1/altura da textura
uniform vec4 u_color;      // cor do outline (rgb)
uniform float u_alpha;     // intensidade do outline (0 a 1)

void main()
{
    vec4 base = texture2D(gm_BaseTexture, v_vTexcoord);
    
    // Se o pixel já é visível, desenha normal
    if (base.a > 0.5)
    {
        gl_FragColor = base;
        return;
    }
    
    // Checa os 4 vizinhos (cima, baixo, esquerda, direita)
    float a = 0.0;
    a += texture2D(gm_BaseTexture, v_vTexcoord + vec2( u_texel.x, 0.0)).a;
    a += texture2D(gm_BaseTexture, v_vTexcoord + vec2(-u_texel.x, 0.0)).a;
    a += texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0,  u_texel.y)).a;
    a += texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0, -u_texel.y)).a;
    
    // Se algum vizinho tem alpha, esse pixel é borda
    if (a > 0.0)
    {
        gl_FragColor = vec4(u_color.rgb, u_alpha);
    }
    else
    {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
    }
}