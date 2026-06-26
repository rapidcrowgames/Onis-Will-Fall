trigger = function()
{
    //Acessa o tutorial
    with (obj_tutorial_jump) {
        destruir = true;
    }
    
    //Destroi o tutorial anterior
    instance_destroy(inst_9FD2347);
}