
///////////////// TODAS FUNÇÕES / FUNCTIONS DO JOGO ////////////////////////////

#region //Screenshake
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

#endregion

#region //Efeito de outline com cor

//Efeito de outline
function init_shader_outline() //Inicia no create as variáveis
{
    //Pega os uniforms do shader uma única vez
    u_outline_texel = shader_get_uniform(sh_outline, "u_texel");
    u_outline_color = shader_get_uniform(sh_outline, "u_color");
    u_outline_alpha = shader_get_uniform(sh_outline, "u_alpha");
    
    //Variáveis de controle do outline
    outline_active   = false;
    outline_color    = [1, 1, 1]; // RGB de 0 a 1 (branco padrão)
    outline_alpha    = 0;
    outline_fade_spd = 0.05; //Velocidade que o alpha cai por frame
}
    

/// USA O OUTLINE ///
/// _color = array [r,g,b] de 0 a 1
/// _alpha = intensidade inicial (sugestão: 0.6 a 0.8 pra ficar suave)
/// _fade_spd = velocidade do fade out (sugestão: 0.02 a 0.08)
function start_outline(_color, _alpha = 0.7, _fade_spd = 0.05)
{
    outline_color    = _color;
    outline_alpha    = _alpha;
    outline_fade_spd = _fade_spd;
    outline_active   = true;
}

/// ATUALIZA O FADE DO OUTLINE (chamar no STEP) ///
function update_outline()
{
    if (!outline_active) return;
    
    outline_alpha -= outline_fade_spd;
    
    if (outline_alpha <= 0)
    {
        outline_alpha  = 0;
        outline_active = false;
    }
}

#endregion

#region //Procura o controle conectado em alguma porta

/// @description Procura por um gamepad conectado e atualiza as globais
function gamepad_find_controller()
{
    // Assume inicialmente que NÃO há controle conectado
    global.gamepad = false;
    global.gamepad_id = -1;
    
    var _qtd = gamepad_get_device_count();
    
    for (var i = 0; i < _qtd; i++)
    {
        if (gamepad_is_connected(i))
        {
            global.gamepad = true;
            global.gamepad_id = i;
            break;
        }
    }
}

#endregion

#region //Squash & Stretch (efeito de esticar)

function init_squash_stretch() //Inicia as variáveis no create
{
    stretch_x = 1;
    stretch_y = 1;
}

function use_squash_stretch(_x = 1, _y = 1) //Use a quantidade que quer esticar
{
    stretch_x = lerp(stretch_x, _x, 0.2);
    stretch_y = lerp(stretch_y, _y, 0.2);
}

function return_squash_stretch(_retorna = 0.1)
{
    stretch_x = lerp(stretch_x, 1, _retorna);
    stretch_y = lerp(stretch_y, 1, _retorna);
}

#endregion