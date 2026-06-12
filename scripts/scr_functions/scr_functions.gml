
///////////////// TODAS FUNÇÕES / FUNCTIONS DO JOGO ////////////////////////////

//Screenshake
function tremor(_forca = 1)
{
	if (instance_exists(obj_manager))
	{
		with (obj_manager)
		{
			if (_forca > treme)
			{
				treme = _forca;
			}
		}
	}
}

function outline_set(_color, _width) {
    shader_set(sh_outline);
    
    var tex = sprite_get_texture(sprite_index, image_index);
    shader_set_uniform_f(shader_get_uniform(sh_outline, "texel_size"), 
        texture_get_texel_width(tex), texture_get_texel_height(tex));
    
    var _r = color_get_red(_color) / 255;
    var _g = color_get_green(_color) / 255;
    var _b = color_get_blue(_color) / 255;
    
    shader_set_uniform_f(shader_get_uniform(sh_outline, "outline_color"), _r, _g, _b, 1);
    shader_set_uniform_f(shader_get_uniform(sh_outline, "outline_width"), _width);
}

function outline_reset() {
    shader_reset();
}

function draw_sprite_outline(_sprite, _image_ind, _x, _y, _xscale, _yscale, _angle, _blend, _alpha, _outline_color, _outline_width) {
    outline_set(_outline_color, _outline_width);
    draw_sprite_ext(_sprite, _image_ind, _x, _y, _xscale, _yscale, _angle, _blend, _alpha);
    outline_reset();
}