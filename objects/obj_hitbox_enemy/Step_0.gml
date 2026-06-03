//SE a HITBOX colidir com o player, ele vai para o estado de HURT SE ele existir
if (instance_exists(obj_player))
{
    if (place_meeting(x, y, obj_player))
    {
        with (obj_player)
        {
            //Faz ele ir para o estado de machucado
            hurt = true;
            attacker = other.owner //pega a referencia de quem criou essa hitbox, no caso o inimigo que me atacou
        } 
    }
}
