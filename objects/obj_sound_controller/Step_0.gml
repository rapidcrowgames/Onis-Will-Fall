// ======================================
// ATUALIZA VOLUME DA MÚSICA
// ======================================

// FADE IN
if (fade_in)
{
    music_volume += fade_speed;
    
    if (music_volume >= global.snd)
    {
        music_volume = global.snd;
        fade_in = false;
    }
    
    audio_sound_gain (music_current, music_volume, 0);

}

// FADE OUT
if (fade_out)
{
    music_volume -= fade_speed;
    
    if (music_volume <= 0)
    {
        music_volume = 0;
        
        audio_sound_gain(music_current, 0, 0);
        
        audio_stop_sound(music_current);
        
        music_current = noone;
        fade_out = false;
        
        // Se tem próxima música
        // começa ela
        if (music_next != noone)
        {
            start_new_music();
        }
    }
}


// ======================================
// CONTROLE DE VOLUME PELO MENU
// ======================================


// Caso o jogador altere global.snd
// atualiza em tempo real
if (music_current != noone)
{
    if (!fade_in && !fade_out)
    {
        audio_sound_gain(music_current, global.snd, 0);
    }
}