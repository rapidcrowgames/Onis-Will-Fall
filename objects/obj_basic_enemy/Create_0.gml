////////////////////////////////
/// VARIÁVEIS DE CONTROLE /////
//////////////////////////////
#region Variáveis de controle

//Variáveis de vida
life = 3;

velh                 = 0;
velv                 = 0;
max_velh             = 1.5;
max_velv             = 6;
grav                 = 0.3;
grav_atual           = grav;
chao                 = false;
dir                  = 1; //Direção em que está olhando --- 1 (Direita) / -1 (Esquerda)

//Variáveis de animação
sprite				 = sprite_index;
image_numb			 = image_number;
image_ind			 = image_index;
image_spd			 = image_speed / 3;
current_animation	 = noone;
attack_done			 = false;

//Variáveis do estado IDLE
idle_timer_change    = 1; //2 Segundos

//Variáveis do estado RUN
run_timer_change     = 10; //10 segundos
destiny_x            = noone;

//Variáveis do estado de ATTACK
attack_done          = false;
create_hitbox        = false;
double_parry         = false;

//Variáveis da detecção do player com a zona de colisão do
//Inimigo
radius               = 100; //Tamanho do raio de colisão circular
in_chase             = false; //Avisa se está ou não em CHASE com o player

//Variáveis do estado de CHASE
target               = noone; //O alvo que está perseguindo
player_last_position = noone; //Pega a última posição do player

//Variáveis do estado LOAD_ATTACK
timer_load_attack    = 0.3; //0.3 segundos

//Variáveis do estado HURT
damage_done          = false; //Garante que sofreu o dano apenas uma vez


//Variáveis de particulas
particula            = noone; //Variável que cuida da criação especifica de uma particula
part_exists          = false; //Identifica se já foi criada a particula
part_timer           = 1.2; //Tempo para deletar a particula após ser criada



#endregion

//////////////////////////////////////
// SISTEMA DE SINCRONIZAR ANIMAÇÃO //
////////////////////////////////////
#region Sistema de sincronizar animação

///// MUDA AS SPRITES ///////
change_sprites = function(_sprites_index = 0)
{	
	current_animation = _sprites_index;
	
	//Checando se a sprite atual é a que eu deveria estar usando
	if (sprite != animations[_sprites_index][0])
	{
		//Zera o indice
		image_ind = 0;
	}
	
	//Muda minha sprite com base no vetor de sprites e minha facing
	sprite = animations[_sprites_index][0];	
	
	//Garante que a sprite vai até o final
	//Pega quantidade de sprites que tem
	image_numb = sprite_get_number(sprite);
	
	//Aumenta o valor da image_ind com base na image_spd
	image_ind += image_spd;
	
	//Zerando o image ind após a animação acabar
	image_ind %= image_numb;
}

/// MUDA A SPRITE E RODA ELA APENAS UMA VEZ ///
change_sprites_once = function(_sprites_index = 0) 
{
    current_animation = _sprites_index;

    if (sprite != animations[_sprites_index][0]) {
        image_ind = 0; // Reinicia só se trocou de sprite
    }

    sprite = animations[_sprites_index][0];
    image_numb = sprite_get_number(sprite);

    // Só avança se ainda não chegou no final
    if (image_ind < image_numb - 1) {
        image_ind += image_spd;
        // Garante que não passa do último frame
        if (image_ind >= image_numb) {
            image_ind = image_numb - 1;
        }
    }
}

#endregion


////////////////////////////////////
/// TODAS ANIMAÇÕES DO INIMIGO ////
//////////////////////////////////
#region Animações do inimigo

animations = [
    [spr_basic_enemie_idle], //inimigo parado
    [spr_basic_enemie_run], //inimigo andando / correndo
    [spr_basic_enemie_attack], //inimigo atacando
    [spr_basic_enemie_hurt], //inimigo machucado
    [spr_basic_enemie_die], //inimigo morrendo
]

#endregion


///////////////////////////////////////////////////
/// ARRUMA A DIREÇÃO QUE O INIMIGO ESTÁ OLHANDO //
/////////////////////////////////////////////////   
#region Corrige a direção que ele está olhando

correct_direction = function()
{
    image_xscale = dir;
    if (velh < 0)  dir  = -1;
    if (velh > 0) dir  =  1;
}

#endregion


///////////////////////////////////
/// ZONA DE DETECÇÃO DO PLAYER ///
/////////////////////////////////
#region Zona que detecta se o player está no raio de visão

player_zone_vission = function()
{
    //Cria um hitbox em formato de circulo
    colission = collision_circle(x, y - sprite_height, radius, obj_player, false, true)
    
    //SE eu colidir, ele entra no estado de perseguir o player
    if (colission)
    {
        //Eu passo a perseguir o player SE já não estiver seguindo
        if (!in_chase) state_enemy = enemy_state.CHASE;
        
        //Está em chase
        in_chase = true;
    }
    else {
        
    	//ele não está mais em chase
        in_chase = false;
        
        //Aqui não altera o estado, quem faz isso é o próprio estado, após o fim do timer
    }
    
}

#endregion


//////////////////////////////////////
/// APLICA A GRAVIDADE NO INIMIGO ///
////////////////////////////////////
#region Aplica a gravidade em tempo real

gravity_real_time = function()
{
    velv += grav_atual;
}

#endregion


/////////////////////////////////
/// ENUM E ESTADOS DO INIMIGO //
///////////////////////////////
#region Enum e Estados do inimigo

//ENUM
enum enemy_state
{
    IDLE,
    RUN,
    CHASE,
    LOAD_ATTACK,
    ATTACK,
    LOAD_HURT,
    HURT,
    DIE
}

//Variáveis do debug de estado e estado atual do inimigo
debug_enemy_state = "";
state_enemy       = enemy_state.IDLE;

//Máquina de estados que faz o Update do estado atual
update_state_enemy = function()
{
    switch (state_enemy) {
    	case enemy_state.IDLE:         state_idle();           break;
    	case enemy_state.RUN:          state_run();            break;
        case enemy_state.CHASE:        state_chase();          break;
    	case enemy_state.LOAD_ATTACK:  state_load_attack();    break;
    	case enemy_state.ATTACK:       state_attack();         break;
    	case enemy_state.LOAD_HURT:    state_load_hurt();         break;
    	case enemy_state.HURT:         state_hurt();           break;
    	case enemy_state.DIE:          state_die();            break;
    }
}


// ------------- ESTADOS ------------------ //
state_idle = function() // PARADO
{
    //Debug de estado
    debug_enemy_state = "Idle";
    
    //Muda sprite para parado
    change_sprites(0);
    
    //Define a velocidade da sprite
    image_spd = image_speed / 9;
    
    //Fica parado
    velh = 0;
    
    //Diminui o timer para trocar de estado
    if (idle_timer_change > 0) idle_timer_change -= delta_time / 1000000;
    
    //SE o timer chegar no 0, ele escolhe se fica parado ou se troca de estado
    if (idle_timer_change <= 0)
    {
        //Reseta o timer
        idle_timer_change = 2;
        state_enemy = choose(enemy_state.IDLE, enemy_state.RUN);
    }
    
    //Muda para o estado de CHASE se eu entrar no raio de visão
    player_zone_vission();
    
    //SE entrar em contato com a hitbox do player, entra no estado de dano
    if (place_meeting(x, y, obj_player_hitbox))
    {
       state_enemy = enemy_state.LOAD_HURT;
    }
}

state_run = function() // CORRENDO
{
    //Debuga o estado
    debug_enemy_state = "Run";
    
    //Muda a sprite para se movendo
    change_sprites(1);
    
    //Define a velocidade da animação
    image_spd = image_speed / 5;
    
    //Diminui o tempo do timer para ele voltar a ficar parado
    if (run_timer_change > 0) run_timer_change -= delta_time / 1000000;
    
    //Se ele colidir com a parede, ele muda de direção
    if (place_meeting(x + sign(dir), y, obj_colisao))
    {
        dir = dir * -1;
        x += dir //Empurra um pixel para fora na nova direção
    }
    
    //Faço ele começar se movendo para direita
    velh = (max_velh * sign(dir));
    
    //Se o timer chegar a 0, então ele volta para o estado parado
    if (run_timer_change <= 0)
    {
        //Reseta o timer
        run_timer_change = 10; //10 segundos
        state_enemy = enemy_state.IDLE;
    }
    
    //Muda para o estado de CHASE se eu entrar no raio de visão
    player_zone_vission();
    
    //SE entrar em contato com a hitbox do player, entra no estado de dano
    if (place_meeting(x, y, obj_player_hitbox))
    {
       state_enemy = enemy_state.LOAD_HURT;
    }
}

state_chase = function() //PERSEGUIÇÃO
{
    //Debuga o estado
    debug_enemy_state = "Chase";
    
    //Altera a sprite para se movendo
    change_sprites(1);
    
    //define a velocidade da animação
    image_spd = image_speed / 5;
    
    //Eu defino o player como ALVO se ele EXISTIR
    if (instance_exists(obj_player)) target = obj_player;
        
    //SE eu tenho um alvo
    if (target != noone)
    {
        //Eu passo a seguir ele
        velh = (max_velh * sign(target.x - x));
    }
    
    //Checa a distância para o alvo
    var _dist = point_distance(x, y, target.x, target.y);

    //SE a minha distância para o player for menor que 48, eu entro no
    //estado de LOAD_ATTACK / pré ataque
    if (_dist < 48)
    {
        //Pego a posição do player por último
        player_last_position = target.x;
        state_enemy = enemy_state.LOAD_ATTACK;
    }
    
    //Verifica ainda se estou ou não dentro do raio de visão
    player_zone_vission();
    
    //SE não estou mais em chase, ele volta para o estado se movendo
    if (!colission && !in_chase)
    {
        //Volta para o estado parado
        state_enemy = enemy_state.RUN;
    }
    
    //SE entrar em contato com a hitbox do player, entra no estado de dano
    if (place_meeting(x, y, obj_player_hitbox))
    {
       state_enemy = enemy_state.LOAD_HURT;
    }
}

state_load_attack = function() // PRÉ ATAQUE
{
    //Debuga o estado
    debug_enemy_state = "load_attack";
    
    //Muda para sprite parado
    change_sprites(0);
    
    //Define a velocidade da animação
    image_spd = image_speed / 9;
    
    //Primeiro eu fico parado
    velh = 0;
    
    //Diminui o timer
    if (timer_load_attack > 0) timer_load_attack -= delta_time / 1000000;
        
    //SE o timer chegar a 0, ele ataca na última posição que o player estava
    if (timer_load_attack <= 0)
    {
        //Faz ele ficar virado para o player
        dir = sign(target.x - x);
        
        //Aumento um pouco a velocidade
        velh = (max_velh * 3 * sign(player_last_position - x));
        
        //Reseto o timer
        timer_load_attack = 0.3;
        
        //Vou para estado do ataque
        state_enemy = enemy_state.ATTACK;
    }
    
    //SE entrar em contato com a hitbox do player, entra no estado de dano
    if (place_meeting(x, y, obj_player_hitbox))
    {
       state_enemy = enemy_state.LOAD_HURT;
    }
}

state_attack = function() // ATACANDO
{
    //Debuga o estado
    debug_enemy_state = "attack";
    
    //Roda apenas uma vez a sprite do ataque
    change_sprites_once(2);
    
    //define a velocidade da animação
    image_spd = image_speed / 5;
    
    //Fica parado
    velh = 0;
    
    //Faz ele ficar virado para o player
    dir = sign(target.x - x);
    
    //Pega os frames da sprite e guarda em uma variável
    var _frame = floor(image_ind);
    
    //Cria a hitbox no Frame 2 da animação e se ainda não tiver criado a hitbox
    if (_frame == 2 && !create_hitbox)
    {
        //Então eu crio a hitbox na minha posição
        var _hitbox = instance_create_layer(x + 6 * dir, y - sprite_height, layer, obj_hitbox_enemy);
        _hitbox.owner = id; //Eu (inimigo) sou o criador dessa hitbox
        
        create_hitbox = true; //Criei ela
    }
    
    //SE minha hitbox colidir com a hitbox do Player SE ela existir, temos um "parry duplo"
    if (instance_exists(obj_player_hitbox))
    {
        if (place_meeting(x, y, obj_player_hitbox))
        {
            //Define que ocorreu o parry duplo
            double_parry = true;
            
            //treme a tela
            tremor(8);
            
            //Cria a particula
            particula = part_system_create(ps_double_parry);
            part_system_position(particula, x + 6 * dir, y - sprite_height);
            
            //Foi criada a particula
            part_exists = true;
            
            //Joga ambos para trás
            if (dir == -1) velh += 50;
            if (dir ==  1) velh -= 50;
                
            with (obj_player) //Joga o player para trás
            {
                double_parry = true;
                if (dir == -1) velh += 50;
                if (dir ==  1) velh -= 50;
            }
            
        } 
    }
        
    //SE criei a hitbox, eu destruo ela no 3 frame da animação
    if (_frame == 3 && create_hitbox)
    {
        //Destruo ela
        instance_destroy(obj_hitbox_enemy);
        create_hitbox = false;
        
        //SE deu o double parry e desativo ele
        if (double_parry)
        {
            double_parry = false;
            
            with (obj_player) 
            {
                double_parry = false;	
            }
        }
    }
    
    //SE acabou a animação, eu volto para o estado normal
    if (image_ind >= sprite_get_number(sprite) - 1)
    {
        //garante que a hitbox vai ser destruida se ainda existir
        if (create_hitbox)
        {
            //Destruo ela
            instance_destroy(obj_hitbox_enemy);
            create_hitbox = false;
        }
        
        //Já terminou o ataque
        attack_done = true;
    }
    
    //SE o ataque já terminou, eu volto para o estado de parado
    if (attack_done)
    {
        in_chase = false;
        attack_done = false; //reset
        state_enemy = enemy_state.IDLE;
    }
}

/////////// EXTRA - DESTRUIR PARTÍCULAS /////////
destroy_particles = function()
{
    //SE a particula já foi criada começa a diminuir o timer
    if (part_exists && part_timer > 0) part_timer -= delta_time / 1000000;
        
    //Quando o timer zerar, ele destroi a partícula
    if (part_timer <= 0)
    {
        part_system_destroy(particula)
        part_timer = 1.2;
        part_exists = false;
    }
}

state_load_hurt = function() // SOFRE O ATAQUE DO INIMIGO
{
    //Debuga o estado
    debug_enemy_state = "Load hurt";
    
    //Muda a sprite para dano
    change_sprites_once(3); 
    
    //Fica parado
    velh = 0;
    
    //Faz ele ficar virado para o player
    dir = sign(target.x - x);
    
    //Define a velocidade da animação
    image_spd = image_speed / 3;
    
    //Pega os frames da animação
    var _frame = floor(image_ind);
    
    //Se estiver no primeiro frame ele da o HITSTOP
    if (_frame == 1)
    {
        //Causa o HITSTOP
        global.hitstop = true
        
        //treme a tela
        tremor(5);
    }
    
    //No fim da animação, ele vai para o estado HURT
    if (image_ind >= sprite_get_number(sprite) - 1)
    {
        state_enemy = enemy_state.HURT;
    }
}

state_hurt = function() // SOFRE O DANO
{
    //Debuga o estado
    debug_enemy_state = "hurt";
    
    //Cria a particula SE ainda não foi criada
    particula = part_system_create(ps_blood);
    part_system_position(particula, x - 30 * dir, y - sprite_height);
    
    //Foi criada a particula
    part_exists = true;
    
    
    //Joga o inimigo para trás
    if (!global.hitstop)
    {
        if (dir ==  1) velh -= 40;
        if (dir == -1) velh += 40;
            
        //Aplica o dano que o inimigo causa apenas 1 vez
        if (!damage_done)
        {
            //Pega o dano que o player causa
            var _dmg_player = obj_player.dano;
            
            //Perde vida se não estiver no DOUBLE PARRY
            if (!double_parry) life -= _dmg_player;  
            
            damage_done = true; //Sofreu o ataque
        }
    }
    
    //SE já sofreu o dano, volta para o estado parado
    if (damage_done)
    {
        damage_done = false;
        state_enemy = enemy_state.CHASE;
    }
    
    //SE a vida acabou, então ele vai para o estado de DIE / MORTE
    if (life <= 0)
    {
        damage_done = false;
        state_enemy = enemy_state.DIE;
    }
}

state_die = function() // MORRE
{
    //Debuga o estado
    debug_enemy_state = "Die";
    
    //Exibe uma vez a animação de morte
    change_sprites_once(4);
    
    //Faz ele ficar virado para o player
    dir = sign(target.x - x);
    
    //Define a velocidade de animação
    image_spd = image_speed / 5
    
    //Fica parado
    velh = 0;
    
    //Deleta o inimigo após o fim da animação
    if (image_ind > sprite_get_number(sprite) - 1)
    {
        instance_destroy(id);
    }
}

#endregion