///////////////////////////
/// DESTRÓI A HITBOX /////
/////////////////////////

//SE eu sair das dimensões da tela eu me destruo
if (x < camera_get_view_x(view_camera[0]) - 100 ||
    x > camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]) + 100 ||
    y < camera_get_view_y(view_camera[0]) - 100 ||
    y > camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]) + 100)
{
    instance_destroy();
}

//SE eu colidir com a parede eu me destruo
if (place_meeting(x, y, obj_colisao))
{
    instance_destroy();
}

//SE eu colidir com o inimigo eu me destruo;
if (place_meeting(x, y, obj_enemy_entity))
{
    instance_destroy();
}