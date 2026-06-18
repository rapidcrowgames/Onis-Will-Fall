/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor

//se desenhando
draw_sprite_ext(sprite, 
image_ind, 
x, 
y, 
stretch_x * dir, 
stretch_y, 
image_angle, 
image_blend, 
image_alpha);





//////////////////////////////
// DEBUG INTERNO PARA TESTE //
//////////////////////////////
#region

if (DEBUG_MODE)
{
	draw_text(x, y - sprite_height - 10, p_timer);	
}

#endregion