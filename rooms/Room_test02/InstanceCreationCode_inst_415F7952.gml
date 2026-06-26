trigger = function()
{
    if (!instance_exists(obj_tutorial_down_plataform))
    {
        instance_create_layer(1228, 159, layer, obj_tutorial_down_plataform);
    }
}