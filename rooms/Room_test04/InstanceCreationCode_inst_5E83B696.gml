trigger = function()
{
    //Acessa o tutorial
    with (obj_tutorial_shot) {
        destruir = true;
    }
    
    //Destroi o tutorial anterior
    instance_destroy(inst_161937AC);
}