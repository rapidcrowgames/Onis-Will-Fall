trigger = function()
{
    //Acessa o tutorial
    with (obj_tutorial_move) {
        destruir = true;
    }
    
    //Destroi o tutorial anterior
    instance_destroy(inst_74E47E91);
}