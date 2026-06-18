//////////////////////////////////
////// VARIÁVEIS DE CONTROLE ////
////////////////////////////////
#region Variáveis de controle

//Variáveis do hitstop
global.hitstop_timer       = 0.05; //Segundos

//Variáveis para screenshake
treme = 0;

//Chama a verificação de controle
gamepad_find_controller();

#endregion


///////////////////////////////
////////// MÉTODOS ///////////
/////////////////////////////   
#region Métodos

hitstop = function() //Método de HITSTOP dos danos
{
    //SE a global histop for TRUE
    //o jogo pausa por 0.05 segundos
    if (global.hitstop)
    {
        //Diminui o timer
        if (global.hitstop_timer > 0) global.hitstop_timer -= delta_time / 1000000;
            
        //SE o timer chegar a 0, então o hitstop para
        if (global.hitstop_timer <= 0) 
        { 
            global.hitstop_timer = 0.05;
            global.hitstop = false;
        }
    }
}

screenshake = function()
{
   //Tremendo a tela
    if (treme > 0.1)
    {
    	//Ele treme a tela 
    	var _x = random_range(-treme, treme) //Altera no eixo X entre positivo e negativo
    	var _y = random_range(-treme, treme) //altera no eixo Y entre positivo e negativo
    	
    	view_set_xport(view_current, _x); //Mexe a câmera atual no eixo X 
    	view_set_yport(view_current, _y); //Mexe a câmare atual no eixo Y
    		
    }
    else //Chego perto de zero, eu garanto que seja zerada
    {
    	treme = 0;
    	view_set_xport(view_current, 0); 
    	view_set_yport(view_current, 0);
    	
    }
    
    
    //Lerp faz a tela parar de tremer gradativamente.
    treme = lerp(treme, 0, 0.1);
     
}

restart_death = function()
{
    //SE o player morreu e exibiu o texto, então
    //posso apertar ENTER para dar restart
    
    //Verifica se o player existe
    if (instance_exists(obj_player))
    {
        var _player = obj_player;
        
        if (_player.player_dead && _player.restart_death)
        {
            if (keyboard_check_pressed(vk_enter))
            {
                game_restart();
            }
        }
    }
}

#endregion