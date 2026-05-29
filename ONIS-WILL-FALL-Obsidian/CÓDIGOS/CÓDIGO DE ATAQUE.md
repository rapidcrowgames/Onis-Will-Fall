```gml
state_attack = function() {
    state_debug = "attack";
    image_spd = image_speed / 3;
    
    change_sprites_once(2);
    
    // Pega o frame atual como inteiro
    var _frame = floor(image_ind);
    
    // Cria a hitbox no frame ativo (ex: frame 2 da animação)
    if (_frame == 2 && !create_hitbox) {
        instance_create_layer(x + 6 * dir, y - sprite_height, layer, obj_player_hitbox);
        create_hitbox = true; // flag: "já foi criada"
    }
    
    // Destrói a hitbox quando sair do frame ativo
    if (_frame > 3 && create_hitbox) {
        instance_destroy(obj_player_hitbox);
        create_hitbox = false;
    }
    
    // Animação terminou, volta pro estado certo
    if (image_ind >= sprite_get_number(sprite) - 1) {
        // Garante que a hitbox some se ainda existir
        if (create_hitbox) {
            instance_destroy(obj_player_hitbox);
            create_hitbox = false;
        }
        attack_done = true;
    }
    
    if (attack_done) {
        attack_done = false;
        state = player_state.IDLE;
    }
}
```
