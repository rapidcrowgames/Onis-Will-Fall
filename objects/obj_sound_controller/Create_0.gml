// ======================================
// Controle geral de música do jogo
// ======================================
#region Variáveis de controle

// Música atual tocando
music_current = noone;

// Volume interno da música
// usado para o fade
music_volume = 0;

// Velocidade do fade
fade_speed = 0.02;

// Música que vai entrar depois do fade
music_next = noone;

#endregion


#region Métodos e funções

// ======================================
// FUNÇÃO PARA TOCAR MÚSICA
// ======================================
function play_music(_music)
{
    // Se já está tocando essa música
    // não faz nada
    if (music_current == _music)
    {
        return;
    }
    
    // Guarda a próxima música
    music_next = _music;
    
    // Se existe uma música tocando
    if (music_current != noone)
    {
        // começa fade out
        fade_out = true;
    }
    
    else
    {
        // se não existe música
        // já inicia direto
        start_new_music();
    }
    
}

// ======================================
// COMEÇA UMA NOVA MÚSICA
// ======================================
function start_new_music()
{
    music_current = music_next;
    
    audio_play_sound(
        music_current,
        10,
        true
    );
    
    // começa silenciosa
    music_volume = 0;
    
    audio_sound_gain
    (
        music_current,
        0,
        0
    );
    
    fade_in = true;
    
}

// ======================================
// PARAR MÚSICA
// ======================================
function stop_music()
{
    if (music_current != noone)
    {
        fade_out = true;
        music_next = noone;
    }
}

#endregion