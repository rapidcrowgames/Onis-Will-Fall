
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

//Garante que o inimigo não entre no chão
ground_collide_correction();

//Garante que um inimigo não entre um dentro do outro
//enemy_collide_correction();

//Retorna do efeito de esticar
return_squash_stretch(0.7);


#endregion