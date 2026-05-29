
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
    draw_circle(destiny_x, y, 15, false);
    draw_text(x, y - sprite_height - 20, debug_enemy_state);
}