
//Me desenho
draw_self();

if (DEBUG_MODE)
{
    draw_circle(destiny_x, y, 15, false);
    draw_text(x, y - sprite_height - 20, debug_enemy_state);
}