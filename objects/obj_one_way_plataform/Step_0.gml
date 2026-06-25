////////////////////////////////////
/// ESTADOS E LÓGICA E MÉTODOS ////
//////////////////////////////////

//SE tem colisão, minha máscara de colisão é a minha
if (global.one_way_collision)
{
    mask_index = spr_one_way_plataform;
}
else {
	//SE não tem colisão, eu mudo minha máscara para sem colisão
    mask_index = spr_one_way_no_collision;
}