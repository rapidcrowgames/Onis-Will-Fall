///////////////////////////////
/// VARIÁVEIS DE CONTROLE ////
/////////////////////////////

///////////////////
///// MÉTODOS ////
/////////////////
stop_song_tp = function()
{
    //Só funciona se o stop_song for true
    if (!stop_song) return;
    
    //Faz com que a música pare quando der o TP
    obj_sound_controller.stop_music();
    
}