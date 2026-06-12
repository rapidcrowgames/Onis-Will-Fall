
//////////////////////////////
/// UTILIZA OS MÉTODOS //////
////////////////////////////
#region Utiliza os métodos

if (global.hitstop) return;
    
//Atualiza os estados do inimigo
update_state_enemy();

//Atualiza a direção que ele está olhando
correct_direction();

//Atualiza a destruição das particulas
destroy_particles();

//Aplica a gravidade
gravity_real_time();

//Atualiza o fade do outline
update_outline();


#endregion