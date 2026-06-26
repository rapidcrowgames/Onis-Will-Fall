trigger = function()
{
    //Acessa o tutorial
    with (obj_tutorial_attack) {
        destruir = true;
    }
    
    //Destroi o tutorial anterior
    instance_destroy(inst_42677075);
}