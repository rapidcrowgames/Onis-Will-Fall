#region teletransporte do player

//SE o player existir
if (instance_exists(obj_player))
{
    //O player colidir comigo
    if (place_meeting(x, y, obj_player))
    {
        //Ele vai para a próxima room
        room_goto(fase);
        
        //Muda a música se ela for escolhida
        if (musica != noone)
        {
            obj_sound_controller.play_music(musica);
        }
        
        //Posiciona o player na fase
        obj_player.x = pos_x;
        obj_player.y = pos_y;
        
        //Faz a câmera se posicionar junto do player
        obj_camera.x = obj_player.x;
        obj_camera.y = obj_player.y;
    }
}

#endregion


#region Controle manual do teletransporte

//Aqui é para usar no código de criação do trigger para caso precise que pare a música
//ou que ele faça outra coisa especifica para tal situação
stop_song_tp();

#endregion