trigger = function()
{
    if (!instance_exists(obj_tutorial_move))
    {
        instance_create_layer(165, 554, layer, obj_tutorial_move);
    }
}