trigger = function()
{
    if (!instance_exists(obj_tutorial_parry))
    {
        instance_create_layer(1262, 844, layer, obj_tutorial_parry);
    }
}