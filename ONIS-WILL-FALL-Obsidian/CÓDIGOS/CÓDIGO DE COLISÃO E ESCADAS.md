Esse código já esta pronto e ele basicamente já verifica a colisão pixel perfect e para subir rampas como se fossem escadas, já pronto e funcionando, só arrumar o nome dos objetos de colisão.

OBS: Esse código é para jogos plataforma
```gml
//Colisão horizontal
var _velh = sign(velh);
repeat(abs(velh))
{
    if (place_meeting(x + _velh, y, obj_colisao))
    {
        // Antes de parar, tenta escalar a rampa pixel a pixel
        var _subiu = false;
        
        for (var _step = 1; _step <= 4; _step++) // 4 = altura máxima escalável por frame (ajuste conforme o ângulo da rampa)
        {
            if (!place_meeting(x + _velh, y - _step, obj_colisao))
            {
                // Conseguiu subir! Move horizontal e sobe
                if (!global.hitstop) {
                    x += _velh;
                    y -= _step;
                }
                _subiu = true;
                break;
            }
        }
        
        // Se não conseguiu subir nenhum pixel, é parede de verdade
        if (!_subiu) {
            velh = 0;
            break;
        }
    }
    else
    {
        if (!global.hitstop) x += _velh;
    }
}

//Colisão vertical
var _velv = sign(velv);
repeat(abs(velv)) 
{
    if (place_meeting(x, y + _velv, obj_colisao))
    {
        velv = 0;
        break;
    }
    else
    {
        if (!global.hitstop) y += _velv;
    }
}

// --- CORREÇÃO DE SLOPE (subida e descida) ---
// Verifica se tem chão logo abaixo do player.
if (place_meeting(x, y + 1, obj_colisao))
{
    // Está no chão — confirma isso para o sistema de física
    chao = true;
}
else if (chao && velv >= 0) // Só age se estava no chão E não está pulando
{
    // Tenta "colar" o player na rampa durante a descida,
    // empurrando ele pra baixo até 4 pixels antes de deixar cair de verdade.
    // Isso elimina o efeito de quicar ao descer.
    var _grudou = false;
    
    for (var _step = 2; _step <= 4; _step++) // Começa em 2 para não conflitar com a checagem do y+1 acima
    {
        if (place_meeting(x, y + _step, obj_colisao))
        {
            // Achou a rampa abaixo — cola o player nela
            if (!global.hitstop) y += _step - 1;
            chao  = true;
            velv  = 0; // Zera a velocidade vertical para não acumular gravidade
            _grudou = true;
            break;
        }
    }
    
    // Se não achou rampa nos 4 pixels, é queda normal — deixa a gravidade agir
}
```