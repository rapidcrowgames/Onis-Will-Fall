trigger = function()
{
    //Acessa o tutorial
    with (obj_tutorial_dash) {
        destruir = true;
    }
    
    //Destroi o tutorial anterior
    instance_destroy(inst_1658545);
}