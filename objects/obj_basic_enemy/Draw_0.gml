//Desenha o outline ATRÁS da sprite, se estiver ativo
if (outline_active)
{
    shader_set(sh_outline);
    
    shader_set_uniform_f(u_outline_texel, texture_get_texel_width(sprite_get_texture(sprite, image_ind)), texture_get_texel_height(sprite_get_texture(sprite, image_ind)));
    shader_set_uniform_f(u_outline_color, outline_color[0], outline_color[1], outline_color[2]);
    shader_set_uniform_f(u_outline_alpha, outline_alpha);
    
    draw_sprite_ext(sprite, image_ind, x, y, 
    stretch_x * dir, 
    stretch_y, 
    image_angle, 
    c_white, 
    1);
    
    shader_reset();
}

//se desenhando (sprite normal)
draw_sprite_ext(sprite, image_ind, x, y, 
stretch_x * dir, 
stretch_y, 
image_angle, 
image_blend, 
image_alpha);


if (DEBUG_MODE)
{
    //Debuga o estado em que está
    draw_text(x, y - sprite_height - 20, timer_load_attack);
    
    //Desenha a colisão circular
    draw_circle(x, y, radius, true);
}