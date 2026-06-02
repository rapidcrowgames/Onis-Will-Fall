//////////////////////////////////
////// VARIÁVEIS DE CONTROLE ////
////////////////////////////////
#region Variáveis de controle

//Variáveis do hitstop
hitstop_timer       = 0.1; //0.1 segundos

#endregion


///////////////////////////////
////////// MÉTODOS ///////////
/////////////////////////////   
#region Métodos

hitstop = function() //Método de HITSTOP dos danos
{
    //SE a global histop for TRUE
    //o jogo pausa por 0.3 segundos
    if (global.hitstop)
    {
        //Diminui o timer
        if (hitstop_timer > 0) hitstop_timer -= delta_time / 1000000;
            
        //SE o timer chegar a 0, então o hitstop para
        if (hitstop_timer <= 0) 
        { 
            hitstop_timer = 0.1;
            global.hitstop = false;
        }
    }
}

#endregion