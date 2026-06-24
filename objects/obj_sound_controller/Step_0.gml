// ============================================================
//  OBJ_SOUND_CONTROLLER — Step Event
//  Atualiza volume e processa fades a cada frame.
// ============================================================

// --- 1. Detecta mudança de volume pelo jogador (ex: menu de pause) ---
if (global.sfx != _last_sfx || global.snd != _last_snd) {
    
    // Atualiza o espelho interno
    _last_sfx = global.sfx;
    _last_snd = global.snd;
    
    // Atualiza TODOS os SFX de uma vez via Audio Group
    // (certifique-se que todos os assets de SFX estão no grupo ag_sfx)
    audio_group_set_gain(ag_sfx, global.sfx, 0);
    
    // Atualiza o volume da música atual imediatamente
    // (exceto se estiver em fade — o fade cuida do volume)
    if (_fade_state == "idle" && music_instance != -1 && audio_is_playing(music_instance)) {
        audio_sound_gain(music_instance, global.snd, 0);
    }
}


// --- 2. Processa o Fade Out ---
if (_fade_state == "fade_out") {
    fade_timer++;
    
    // Calcula o volume atual diminuindo progressivamente
    var _vol = global.snd * (1 - (fade_timer / fade_duration));
    _vol = max(_vol, 0); // Garante que não fique negativo
    
    if (music_instance != -1 && audio_is_playing(music_instance)) {
        audio_sound_gain(music_instance, _vol, 0);
    }
    
    // Quando o fade out terminar...
    if (fade_timer >= fade_duration) {
        // Para a música antiga
        if (music_instance != -1) {
            audio_stop_sound(music_instance);
            music_instance = -1;
            music_current  = -1;
        }
        
        // Inicia fade in da próxima (se houver)
        _start_fade_in();
    }
}


// --- 3. Processa o Fade In ---
if (_fade_state == "fade_in") {
    fade_timer++;
    
    // Calcula o volume atual aumentando progressivamente
    var _vol = global.snd * (fade_timer / fade_duration);
    _vol = min(_vol, global.snd); // Garante que não ultrapasse o volume máximo
    
    if (music_instance != -1 && audio_is_playing(music_instance)) {
        audio_sound_gain(music_instance, _vol, 0);
    }
    
    // Quando o fade in terminar...
    if (fade_timer >= fade_duration) {
        // Garante que está no volume correto
        audio_sound_gain(music_instance, global.snd, 0);
        _fade_state = "idle";
        fade_timer  = 0;
    }
}