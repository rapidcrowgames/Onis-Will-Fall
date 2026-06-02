
//se desenhando
draw_sprite_ext(sprite, 
image_ind, 
x, 
y, 
image_xscale, 
image_yscale, 
image_angle, 
image_blend, 
image_alpha);

if (DEBUG_MODE)
{
    //Debuga o estado em que está
    draw_text(x, y - sprite_height - 20, life);
    
    //Desenha a colisão circular
    draw_circle(x, y, radius, true);
}