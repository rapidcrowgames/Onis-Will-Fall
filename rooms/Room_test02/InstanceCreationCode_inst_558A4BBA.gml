trigger = function()
{
    //Acessa o tutorial
    with (obj_tutorial_down_plataform) {
        destruir = true;
    }
    
    //Destroi o tutorial anterior
    instance_destroy(inst_415F7952);
}