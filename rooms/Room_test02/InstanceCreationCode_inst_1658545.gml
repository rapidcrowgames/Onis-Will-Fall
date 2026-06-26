trigger = function()
{
    if (!instance_exists(obj_tutorial_dash))
    {
        instance_create_layer(1330, 615, layer, obj_tutorial_dash);
    }
}