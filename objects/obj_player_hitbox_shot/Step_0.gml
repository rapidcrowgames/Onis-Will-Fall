//SE eu sair das dimensões da tela eu me destruo
if (x < camera_get_view_x(view_camera[0]) - 100 ||
    x > camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]) + 100 ||
    y < camera_get_view_y(view_camera[0]) - 100 ||
    y > camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]) + 100)
{
    instance_destroy();
}