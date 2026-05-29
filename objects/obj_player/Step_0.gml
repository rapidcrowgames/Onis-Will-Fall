
////////////////////////
// UTILIZA OS MÉTODOS //
////////////////////////
#region

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
	//show_debug_message(life);	
    
    show_debug_overlay(true);
}


#endregion