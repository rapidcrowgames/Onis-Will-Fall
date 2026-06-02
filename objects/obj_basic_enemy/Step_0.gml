
//////////////////////////////
/// UTILIZA OS MÉTODOS //////
////////////////////////////
#region Utiliza os métodos

if (global.hitstop) return;
    
//Atualiza os estados do inimigo
update_state_enemy();

//Atualiza a direção que ele está olhando
correct_direction();

#endregion

show_debug_message(life)