trigger = function()
{
    if (!instance_exists(obj_tutorial_shot))
    {
        instance_create_layer(229, 481, layer, obj_tutorial_shot);
    }
}