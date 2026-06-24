// ============================================================
//  OBJ_SOUND_CONTROLLER — Create Event
//  Controlador central de áudio do jogo.
//  Gerencia volume global (SFX e Música) e transições com fade.
// ============================================================

// --- Configurações de Fade ---
fade_duration   = 60;   // Duração do fade em frames (60 = 1 segundo a 60fps)
fade_timer      = 0;    // Timer interno do fade
fade_in_speed   = 0;    // Calculado automaticamente
fade_out_speed  = 0;    // Calculado automaticamente

// --- Estado interno das músicas ---
music_current   = -1;   // Asset de música tocando agora
music_next      = -1;   // Próxima música a tocar (durante troca)
music_instance  = -1;   // Instance do audio_play_sound da música atual

// --- Volumes internos (espelho das globais, para detectar mudança) ---
_last_sfx       = global.sfx;
_last_snd       = global.snd;

// --- Estado do fade ---
// "idle"     → nenhum fade acontecendo
// "fade_out" → diminuindo volume da música atual antes de trocar
// "fade_in"  → aumentando volume da nova música
_fade_state = "idle";

// ============================================================
//  FUNÇÕES DO CONTROLADOR
//  Todas as funções abaixo são methods desse objeto.
//  Use-as externamente via: obj_sound_controller.play_music(snd_boss)
// ============================================================


// ------------------------------------------------------------
//  play_music(novo_asset)
//  Inicia uma nova música com fade in/out automático.
//  Se já houver uma música tocando, faz fade out dela primeiro.
//
//  Exemplo de uso:
//    obj_sound_controller.play_music(snd_boss_1);
//    obj_sound_controller.play_music(snd_overworld);
// ------------------------------------------------------------
play_music = function(_new_music) {
    // Se for a mesma música já tocando, ignora
    if (_new_music == music_current && audio_is_playing(music_instance)) {
        exit;
    }
    
    music_next = _new_music;
    
    if (music_current != -1 && audio_is_playing(music_instance)) {
        // Já tem música tocando → faz fade out primeiro, depois fade in da nova
        _fade_state  = "fade_out";
        fade_timer   = 0;
        fade_out_speed = global.snd / fade_duration; // quanto diminuir por frame
    } else {
        // Nenhuma música tocando → começa direto com fade in
        _start_fade_in();
    }
}


// ------------------------------------------------------------
//  stop_music()
//  Para a música atual com fade out suave.
//
//  Exemplo de uso:
//    obj_sound_controller.stop_music();
// ------------------------------------------------------------
stop_music = function() {
    if (music_current != noone && audio_is_playing(music_instance)) 
    {
        music_next   = -1; // Sem próxima música (só para)
        _fade_state  = "fade_out";
        fade_timer   = 0;
        fade_out_speed = global.snd / fade_duration;
    }
}


// ------------------------------------------------------------
//  play_sfx(asset)
//  Toca um efeito sonoro respeitando o volume global de SFX.
//  Use sempre que for tocar um som de efeito (pulo, tiro, etc.)
//
//  Exemplo de uso:
//    obj_sound_controller.play_sfx(snd_jump);
//    obj_sound_controller.play_sfx(snd_hit);
// ------------------------------------------------------------
play_sfx = function(_sfx_asset) {
    var _inst = audio_play_sound(_sfx_asset, 10, false);
    audio_sound_gain(_inst, global.sfx, 0);
    return _inst; // Retorna a instância caso queira manipular depois
}


// ------------------------------------------------------------
//  _start_fade_in()   ← Função interna (prefixo _ = privada)
//  Inicia a reprodução da próxima música com fade in.
//  NÃO chame essa função diretamente de fora do objeto.
// ------------------------------------------------------------
_start_fade_in = function() {
    music_current    = music_next;
    music_next       = -1;
    
    if (music_current == -1) {
        // Se não tem próxima música, só limpa o estado
        _fade_state = "idle";
        exit;
    }
    
    // Toca a nova música com volume 0 (vai aumentar no fade in)
    music_instance = audio_play_sound(music_current, 5, true); // loop = true
    audio_sound_gain(music_instance, 0, 0); // começa mudo
    
    _fade_state    = "fade_in";
    fade_timer     = 0;
    fade_in_speed  = global.snd / fade_duration; // quanto aumentar por frame
}