trigger = function()
{
    if (!instance_exists(obj_tutorial_attack))
    {
        instance_create_layer(168, 238, layer, obj_tutorial_attack);
    }
}