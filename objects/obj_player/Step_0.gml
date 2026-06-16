
////////////////////////
// UTILIZA OS MÉTODOS //
////////////////////////
#region

if (global.hitstop) return;

//Movimenta o player
if (!global.cutscene) move_player();

//Atualiza os estados do player
update_state();

//Controla o tempo de invencibilidade após sofrer um dano
step_damage();

#endregion



//////////////////////////////
// DEBUG INTERNO PARA TESTE //
//////////////////////////////
#region

if (DEBUG_MODE)
{
    //Reseta a room
    if (keyboard_check_pressed(ord("R")))
    {
        room_restart();
    }
    
    //Reseta o jogo
    if (keyboard_check_pressed(ord("T")))
    {
        game_restart();
    }
    
}


#endregion