/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor

//Utiliza o trigger apenas se colidir com o player
//SE o player existir
if (instance_exists(obj_player))
{
	if (place_meeting(x, y, obj_player)) trigger();
}