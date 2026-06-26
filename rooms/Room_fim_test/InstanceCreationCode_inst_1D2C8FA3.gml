
trigger = function()
{
    //SE não existe
    if (!instance_exists(obj_txt_end_game))
    {
        //Eu crio ele
        instance_create_layer(245, 76, layer, obj_txt_end_game);
    }
    
    //Defino qual a animação do player
    with (obj_player)
    {
        cutscene_action = "idle";
        
        state = player_state.CUTSCENE;
        
        global.cutscene = true;
    }
}