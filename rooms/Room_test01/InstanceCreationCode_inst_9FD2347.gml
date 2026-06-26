trigger = function()
{
    if (!instance_exists(obj_tutorial_jump))
    {
        instance_create_layer(645, 569, layer, obj_tutorial_jump);
    }
}