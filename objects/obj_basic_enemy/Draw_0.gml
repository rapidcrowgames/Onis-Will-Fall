
//se desenhando
if (parry_window) {
    draw_sprite_outline(sprite, image_ind, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha, c_yellow, 1);
} else {
    draw_sprite_ext(sprite, image_ind, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}


if (DEBUG_MODE)
{
    //Debuga o estado em que está
    draw_text(x, y - sprite_height - 20, atk_cooldown);
    
    //Desenha a colisão circular
    draw_circle(x, y, radius, true);
}