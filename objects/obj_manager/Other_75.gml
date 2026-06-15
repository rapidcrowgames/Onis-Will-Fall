// O GameMaker preenche automaticamente o "async_load" com informações
// sempre que algo do sistema acontece (incluindo gamepad conectado/desconectado)

if (async_load[? "event_type"] == "gamepad discovered")
{
    var _pad = async_load[? "pad_index"];
    
    // Define a deadzone direto na API do GameMaker (opcional, ver nota abaixo)
    gamepad_set_axis_deadzone(_pad, 0.2);
    
    // Reaproveita nossa function pra atualizar as globais
    gamepad_find_controller();
}
else if (async_load[? "event_type"] == "gamepad lost")
{
    gamepad_find_controller();
}