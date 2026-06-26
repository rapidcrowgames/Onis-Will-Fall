trigger = function()
{
    //Acessa o tutorial
    with (obj_tutorial_parry) {
        destruir = true;
    }
    
    //Destroi o tutorial anterior
    instance_destroy(inst_DB75280);
}