
///////////////////////////////
// VARIÁVEIS DE CONTROLE //
//////////////////////////////
#region Variáveis de controle

//Variávis de personagem (vida, mana, etc...)
life = 5; //Inicialmente 5 vidas

//Variáveis de DANO
dano                 = 1;

//Variáveis de fisíca
velh		         = 0;
velv	          	 = 0;
max_velh	         = 4;
max_velv	         = 8;
grav		         = 0.3;
grav_atual	         = grav;
chao		         = noone;
parede               = noone;
is_jumping           = false; //Verifica se estou pulando
dir			         = 1 // 1 - Direita / -1 Esquerda

//Variáveis de estados
hurt                 = false; //Identifica se sofreu dano ou não
esquive_force        = 20; //Força da esquiva
wall_jump_force      = 10; //Força do pulo da parede

//Variáveis do estado de ATTACK
create_hitbox	     = false; //Cria a hitbox
combo_count          = 0;
combo_buffered       = false; //Verifica se foi pressionado o botão novamente
attack_timer         = 0.13; //Janela de timer para dar o próximo golpe
double_parry         = false; //identifica se ambos atacaram no mesmo momento

//Variáveis do estado HURT / machucado
hurt_invencible		 = false;
hurt_timer			 = 1 // 1 segundos
attacker             = noone; //Variável que salva quem foi que me atacou

//Variável do estado de CUTSCENE
cutscene_action      = noone; //Define qual ação do SWITCH da cutscene

//Variáveis do estado de PARRY
parry_timer          = 0.5;
parry                = false;

//Variáveis do estado DEATH
player_dead          = false;
restart_death        = false; //Variável que cuida do texto para dar restart game

//Variáveis do estado de WALL / Wall jump
wall_right           = false;
wall_left            = false;

//Variáveis de particulas
particula            = noone; //Variável que cuida da criação especifica de uma particula
part_exists          = false; //Identifica se já foi criada a particula
part_timer           = 1.2; //Tempo para deletar a particula após ser criada

//Variáveis de animação
sprite				 = sprite_index;
image_numb			 = image_number;
image_ind			 = image_index;
image_spd			 = image_speed / 3;
current_animation	 = noone;
attack_done			 = false;

#endregion


/////////////////////////////
// VARIÁVEIS DE INPUTS ///
////////////////////////////
#region	Variáveis de Inputs

get_inputs = function()
{	
	//Pega as teclas
	input_right			= keyboard_check(ord("D")) or keyboard_check(vk_right);
	input_left			= keyboard_check(ord("A")) or keyboard_check(vk_left);
	input_jump			= keyboard_check(ord("W")) or keyboard_check(vk_space);
	input_attack		= keyboard_check_pressed(ord("J")) or keyboard_check_pressed(ord("Z"));
    input_parry         = keyboard_check_pressed(ord("K")) or keyboard_check_pressed(ord("X"));
    input_esquive       = keyboard_check_pressed(vk_shift);
}

#endregion


/////////////////////////////////
// INICIA OBJETOS COM O PLAYER //
////////////////////////////////
#region Inicia objetos com o player

//Inicia a câmera com o player SE ainda não foi iniciado
instance_create_layer(x, y, layer, obj_camera);

//Se a câmera existe, já inicia com ela seguindo o player
if (instance_exists(obj_camera))
{
	with (obj_camera)
	{
		follow = true;	
	}
}

#endregion


////////////////////////////////
// TODAS ANIMAÇÕES DO PLAYER //
//////////////////////////////
#region Todas animações do player

animations = 
[
	[spr_player_idle], //Animação parado - 0
	[spr_player_run], //Animação se movendo - 1
	[spr_player_attack_1], //animação atacando - 2
	[spr_player_attack_2], //animação atacando - 3 combo cout
	[spr_player_attack_3], //animação atacando - 4 combo cout
	[spr_player_parry], //animação defesa - 5
	[spr_player_hurt], //animação machucado - 6
    
    //Novas animações [Pulo, queda, ataque 1 e 2, Parede]
    [spr_player_jump], //Animação de pulo (subida) - 7
    [spr_player_fall], //Animação de pulo (queda) - 8
    [spr_player_death], //Animação de morte - 9
    [spr_player_esquive], //Animação de esquiva (para trás) - 10
    [spr_player_jump_wall], //Animação de esquiva (para trás) - 11
]

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


////////////////////////////
// VARIÁVEIS DE MOVIMENTO //
///////////////////////////
#region Variáveis de movimento

move_player = function()
{
    if (global.hitstop) return;
    if (state == player_state.ESQUIVE) return;
    if (state == player_state.HURT) return;
    if (state == player_state.DEATH) return;
        
	//Pega os inputs SE não estiver no hitstop
	get_inputs();
	
	//Movimento horizontal
	velh = (input_right - input_left) * max_velh;
	
	//Aplica a gravidade
	velv += grav_atual;
	
	//Calcula a direção
	if (velh > 0) dir =  1;
	if (velh < 0) dir = -1;
	
	//Identifica se está ou não no chão		   //Está no chão	 //Não está no chão
	if (place_meeting(x, y + 1, obj_colisao))  {chao = true;} else {chao = false;}
	
    //Identifica se está ou não na parede             //Está na parede      //Não está na parede
    if (place_meeting(x + sign(dir), y, obj_colisao))  {parede = true;} else {parede = false;}
    
    //Pega os lados da parede         //Está na direita ou Esquerda   //Não está na direita ou esquerda
    if (place_meeting(x + 1, y, obj_colisao)) {wall_right = true} else {wall_right = false;}
    if (place_meeting(x - 1, y, obj_colisao)) {wall_left = true} else {wall_left = false;}
	
	
	/////////////////////////
	// LÓGICA DO PULO //////
	///////////////////////
	#region Lógica do pulo
    	
	//SE estou no chão e aperto ou seguro o botão / tecla de pular
	if (chao)
	{
		if (input_jump)
		{
			//Executa o pulo com valor máximo de max_velv
			velv -= max_velv;
            //Estou pulando
            is_jumping = true;
		}
		
	}
	
	//Se não estou mais no chão
	if (velv < 0 && is_jumping)
	{
		//E se ainda estou segurando o botão a gravidade fica mais baixa
		if (input_jump)
		{
			grav_atual = 0.25;	
		}
		else
		{
			//SE eu soltar o botão a gravidade volta a ficar mais alta
			grav_atual = 1;	
		}
	}
	else
	{
		//A gravidade volta a ficar normal
		grav_atual = grav;
        is_jumping = false;
	}
    
    //SE estou pulando, vou para o estado de pulo
    if (is_jumping)
    {
        state = player_state.JUMP;
    }
	
	#endregion
    
    /////////////////////////////////
    ////// LÓGICA DA PAREDE ////////
    ///////////////////////////////
    #region Lógica da parede
    
    //SE estou na parede, a gravidade me puxa para baixo
    if (parede && !chao)
    {
        is_jumping = false;
        
        //Vai para o estado wall jump
        state = player_state.WALL_JUMP;
    }
    
    #endregion
    
    
    ////////////////////////////
    //// LÓGICA DA ESQUIVA ////
    //////////////////////////
    #region Lógica da esquiva

    if (chao && input_esquive)
    {
        velh = dir * esquive_force;
        hurt_invencible = true;
        state = player_state.ESQUIVE;
    }
    
    #endregion
    
    //Aplica a direção
	image_xscale = dir;
}


#endregion


//////////////////////////////
// ENUM E MÁQUINA DE ESTADOS //
/////////////////////////////
#region Máquina de estados e ENUM

enum player_state
{
	IDLE, //Estado parado
	RUN, //Estado em movimento / corrida
	JUMP, //Estado de pulo
	HURT, //Estado sofrendo dano
	ATTACK, //Estado de ataque
    PARRY, //Estado de parry / defesa
	DEATH, //Esta de morte
	ESQUIVE, //Esta de esquiva
    WALL_JUMP, //Estado de pulo na parede
	CUTSCENE //Estado de cena / cutscene
}

//Variáveis para controle da state machine
//E debug de estado
state_debug = noone;
state = player_state.IDLE;

update_state = function()
{
	switch(state) //Máquina de estados
	{
		case player_state.IDLE:                state_idle();        break; //estado parado	
		case player_state.RUN:                 state_run();         break; //estado correndo / se movendo
		case player_state.JUMP:                state_jump();        break; //estado de pulo
		case player_state.HURT:                state_hurt();        break; //estado sofrendo dano	
		case player_state.ATTACK:              state_attack();      break; //estado atacando	
		case player_state.ESQUIVE:             state_esquive();     break; //estado esquiva
		case player_state.PARRY:               state_parry();       break; //estado parry defesa	
		case player_state.DEATH:               state_death();       break; //estado de morte
		case player_state.WALL_JUMP:           state_wall();        break; //estado de pulo na parede
		case player_state.CUTSCENE:            state_cutscene();    break; //estado de cutscene
	}
}


//////// ESTADOS DO PLAYER ///////////

state_idle = function() //Estado PARADO / IDLE
{
	//Debug de estado
	state_debug = "idle";
	
	//Muda a sprite parado
	change_sprites(0);
	
	//Se move um pouco mais devagar a animação
	image_spd = image_speed / 6;
	
	//Se apertar uma das teclas ou analógico de movimento horizontal
	//Ele vai para o estado de RUN
	if (input_right xor input_left) state = player_state.RUN;
	
	//Se apertar a tecla / botão de ataque vai para estado de ATTACK
	if (input_attack) state = player_state.ATTACK;
	
	//Se eu sofrer dano, vai para o estado de HURT
	if (hurt) 
    {
        global.hitstop = true;
        state = player_state.HURT;
    }
    
    //SE apertar o botão do parry, ele vai para PARRY
    if (input_parry && !hurt) state = player_state.PARRY;
	
	//Se perder todas vidas, vai para o estado de morte
	if (life <= 0) state = player_state.DEATH;
	
}

state_run = function() //Estado MOVIMENTO / RUN
{
	//Debug de estado
	state_debug = "run"
	
	//Muda a sprite andando
	change_sprites(1);
	
	//Se move na velocidade normal a sprite
	image_spd = image_speed / 4;
	
	//Se soltar as teclas ou analógico de movimento, volta
	//para o estado parado
	if (!input_right && !input_left) state = player_state.IDLE;
	
	//Se apertar a tecla / botão de ataque vai para estado de ATTACK
	if (input_attack) state = player_state.ATTACK;
	
	//Se ele sofrer dano, vai para o estado de HURT
	if (hurt) 
    {
        global.hitstop = true;
        state = player_state.HURT;
    }
    
    //SE apertar o botão do parry, ele vai para PARRY
    if (input_parry && !hurt) state = player_state.PARRY;
	
	//Se perder todas vidas, vai para o estado de morte
	if (life <= 0) state = player_state.DEATH;
	
}

state_jump = function() //Estado PULANDO / JUMP
{
	//Debug de estado
	state_debug = "jump";
	
	//Muda para a sprite de pulo (quando tiver)
	if (is_jumping)
    {
        change_sprites_once(7)
    }
    
    //Quando já estiver mais alto e em queda, muda para sprite de queda
    if (!is_jumping)
    {
        change_sprites(8);
    }
    
    //define a velocidade das animações
    image_spd = image_speed / 5;
	
	////Se ele sofrer dano, vai para o estado de HURT
	if (hurt) state = player_state.HURT;
	
	////Se perder todas vidas, vai para o estado de morte 
	if (life <= 0) state = player_state.DEATH;
	
	//Se estiver no chão volta para o estado de parado
	if (chao) state = player_state.IDLE;
	
}

state_attack = function() //Estado ATAQUE / ATTACK
{
    //Debug de estado
    state_debug = "attack";
    
    //Velocidade da animação
    image_spd = image_speed / 3.5;
    
    //SE apertar o botão do parry, ele vai para PARRY
    if (input_parry && !hurt) state = player_state.PARRY;
    
    //Roda a animação do golpe atual apenas uma vez
    change_sprites_once(2 + combo_count); // 2 = primeiro ataque no array
    
    // Buffer: guarda o input de ataque pressionado DURANTE a animação
    if (input_attack) combo_buffered = true;
    
    //Criação da hitbox no frame ativo
    if (floor(image_ind) == 2 && !create_hitbox)
    {
        instance_create_layer(x + 6 * dir, y - sprite_height + 10, layer, obj_player_hitbox);
        create_hitbox = true;
    }
    
    //Destroi a hitbox quando sair do frame ativo
    if (floor(image_ind) > 3 && create_hitbox)
    {
        instance_destroy(obj_player_hitbox);
        create_hitbox = false;
    }
    
    // ── ANIMAÇÃO TERMINOU ─────────────────────────────────────────────
    if (image_ind >= sprite_get_number(sprite) - 1)
    {
        // Congela no último frame enquanto o timer corre
        image_spd = 0;
        
        // SE tem combo buffered E ainda cabe mais um golpe: encadeia
        if (combo_buffered && combo_count < 2) // máximo 3 golpes (0, 1, 2)
        {
            image_ind = 0;          //Reinicia a animação pro próximo golpe
            image_spd = image_speed / 3.5; //Retoma a velocidade da animação
            combo_count++;
            combo_buffered = false; //Limpa o buffer
            attack_timer = 0.13;     //Reseta o timer para o novo golpe
        }
        else
        {
            // ── SEM COMBO: decrementa o timer de recovery ─────────────
            // Esse delay dá a sensação de peso no último golpe
            attack_timer -= delta_time / 1000000;
            
            if (attack_timer <= 0)
            {
                //Timer zerou: encerra o estado de ataque
                attack_timer = 0.13;  //Reseta o timer para o próximo uso
                combo_count = 0;
                combo_buffered = false;
                attack_done = true;
            }
        }
    }
    
    if (attack_done)
    {
        attack_done = false;
        state = player_state.IDLE;
    }
}

state_hurt = function() //Estado MACHUCADO / HURT
{
    //Debug do estado
    debug_state = "Hurt";
    
    //Velocidade da animação
    image_spd = image_speed / 3;
    
    //Altera para animação 1 vez para de machucado
    change_sprites_once(6);
    
    //Perde vida e joga para trás apenas UMA VEZ (quando não é invencivel ainda)
    if (!hurt_invencible)
    {
        if (double_parry or parry) 
        {
            hurt = false;
            return;
        }
        else {
            
            //treme a tela
            tremor(15);
            
            //Perde vida SE não estão em parry duplo
            life--;
            
            //Joga o player para trás
            if (dir == -1)  velh += 5; //Joga ele para direita
            if (dir ==  1)  velh -= 5; //Joga ele para esquerda
            
            //Fica invencivel e opaco
            hurt_invencible = true;
            image_alpha = 0.5;
        }
        
        
    }
    
    //Se a vida chegar a 0 vai para o estado de DEATH
    if (life <= 0)
    {
        state = player_state.DEATH;
    }
    
    //No fim da animação, volta para o estado parado
    if (image_ind >= sprite_get_number(sprite) - 1)
    {
        hurt = false; //Não estou mais machucado
        state = player_state.IDLE;
    }
}

state_parry = function() //Estado DEFESA / PARRY
{
    //Debuga o estado 
    state_debug = "Parry";
    
    //Define a animação de parry
    change_sprites_once(5);
    
    //Fica parado
    velh = 0;
    
    //Define a velocidade da animação
    image_spd = image_speed / 3;
    
    //Pega os frames da imagem
    var _frame = floor(image_ind);
    
    //A partir do frame 2 que abre a janela de parry
    if (_frame >= 6 && !parry)
    {
        parry = true;
    }
    
    //SE estou na janela de parry
    if (parry)
    {
        if (parry_timer > 0) parry_timer -= delta_time / 1000000;
            
        //SE eu sofrer dano dentro deste tempo jogo quem me atacou para longe
        var _hitbox = instance_place(x, y, obj_hitbox_enemy);
        if (_hitbox != noone)
        {
            
            //Cria a particula
            particula = part_system_create(ps_parry);
            part_system_position(particula, x + 20 * dir, y - sprite_height);
            
            //Foi criada a particula
            part_exists = true;
            
            with (_hitbox.owner)
            {
                //treme a tela
                tremor(8);
                if (dir == -1) velh += 20;
                if (dir ==  1) velh -= 20;
            }
            //Reseta o parry após executar
            hurt = false;
            parry = false;
            parry_timer = 0.5;
        }

    }
    
    //SE o tempo esgotar sem parry, fecha a janela
    if (parry_timer <= 0)
    {
        parry_timer = 0.5;
        parry = false;
    }
    
    //No fim da animação volta para IDLE
    if (image_ind >= sprite_get_number(sprite) - 1)
    {
        parry = false;        // garante reset
        parry_timer = 0.5;    // garante reset
        state = player_state.IDLE;
    }
}

state_esquive = function() //Estado ESQUIVA // ESQUIVE
{
    //Debuga o estado
    state_debug = "Esquive front";
    
    //Muda para animação da esquiva de costas
    change_sprites_once(10);
    
    //Define a velocidade da animação
    image_spd = image_speed / 3;
    
    //Diminui a velocidade do player
    velh = lerp(velh, 0, 0.1);
    
    //Fica invencivel
    hurt_invencible = true;
    
    //No fim da animação ele sai do estado
    if (image_ind >= sprite_get_number(sprite) - 1)
    {
        state = player_state.IDLE;
    }
}

state_wall = function() //Estado de PULO NA PAREDE // WALL JUMP
{
    //Debuga o estado
    state_debug = "Wall";
    
    // Animação de estar na parede
    change_sprites(11);
    
    //Define a velocidade da animação
    image_spd = image_speed / 4;
    
    //SE estiver na parede da direita
    if (!chao && parede && wall_right)
    {
        //Ele fica virado para esquerda
        dir = -1;
        image_xscale = dir; // Aplica depois de corrigir
    }
    
    //SE estiver na parede da esquerda
    if (!chao && parede && wall_left)
    {
        //Ele fica virado para direita
        dir = 1;
        image_xscale = dir; // Aplica depois de corrigir
    }
    
    
    //SE cair no chão e não estiver na parede, ele volta para o estado IDLE
    if (chao && !parede && !wall_right && !wall_left)
    {
        state = player_state.IDLE;
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

/////// EXTRA: Invencibilidade do dano sofrido //////////
step_damage = function()
{
	//SE eu sofri o dano e ativei a invencibilidade
	if (hurt_invencible)
	{
		//Ativo o timer
		hurt_timer -= delta_time / 1000000;
	}
	
	//Quando o timer esgotar, ele não é mais invencivel
	if (hurt_timer <= 0)
	{
		image_alpha		= 1; //Opacidade volta ao normal
		hurt_invencible = false;
		hurt_timer		= 1; //1 segundo novamente
	}
}

state_death = function() //Estado MORTE / DIE
{
    //Debuga o estado
    state_debug = "Death";
    
    //Muda para a sprite de morte
    change_sprites_once(9);
    
    //Define a velocidade da animação
    image_spd = image_speed / 12;
    
    // Só chama uma vez ao entrar no estado de morte
    if (!player_dead)
    {
        player_dead = true;
        room_goto(rm_death);
        
        //Atualizo minha posição
        x = 256;
        y = 180;
        
        //Desliga a gravidade
        grav_atual = 0;
        
        //Atualizo a posição da minha câmera
        if (instance_exists(obj_camera))
        {
            obj_camera.x = x;
            obj_camera.y = y;
        }
    }
    
    //Aplica zoom suave todo frame (precisa rodar fora do if para funcionar)
    if (instance_exists(obj_camera))
    {
        var _cam = view_camera[0];
        
        //Tamanho alvo do zoom (menor = mais próximo)
        var _target_w = 180;
        var _target_h = 100;
        
        //Pega o tamanho atual da câmera
        var _current_w = camera_get_view_width(_cam);
        var _current_h = camera_get_view_height(_cam);
        
        //Lerp suaviza o zoom gradualmente
        var _new_w = lerp(_current_w, _target_w, 0.05);
        var _new_h = lerp(_current_h, _target_h, 0.05);
        
        //Aplica o novo tamanho da câmera
        camera_set_view_size(_cam, _new_w, _new_h);
        
        //Centraliza a câmera no player suavemente
        //Diminui o offset_y para subir a câmera, aumenta para descer
        var _offset_y = 130; // <- ajusta esse valor até centralizar bem
        
        var _cam_x = lerp(camera_get_view_x(_cam), x - _new_w / 2, 0.1);
        var _cam_y = lerp(camera_get_view_y(_cam), (y - _offset_y) - _new_h / 2, 0.1);
        camera_set_view_pos(_cam, _cam_x, _cam_y);
    }
    
    //Se chegar no fim da animação então ele exibe o texto de restart game
    if (image_ind >= sprite_get_number(sprite) - 1)
    {
        restart_death = true;
    }
}

state_cutscene = function() //Estado CENA / CUTSCENE
{
	//Debug de estado
	debug_state = "cutscene";
	
	//Velocidade da animação
	image_spd = image_speed / 6;
	
	//Não tem controle dos inputs
	
	//Para a velocidade dele
	velh = 0;
	
	//SWITCH que cuida dos estados e animações da cutsce
	switch(cutscene_action)
	{
		case "idle"		: change_sprites(0); break;	
		case "walk"		: change_sprites(1); break;	
		case "attack"	: change_sprites(2); break;	
		//colocar mais depois
	}
	
	#region //DICA de como usar corretamente a cutscene
	
	//Se for chamar durante um tragger ou por outro envento, basta
	//acessar o WITH do player, colocar em qual CASE do CUTSCENE_ACTION
	//quer que ele vá, e colocar o STATE dele em PLAYER_STATE_CUTSCENE
	
	//Pronto assim, ele vai para o estado de cutscene, onde só obedece os 
	//comandos da cena
	
	//Ex:
	//trigger = function()
	//{
		//with (obj_player)
		//{
			//cutscene_action = "idle";
			//state = player_state.CUTSCENE;
			//global.cutscene = true;
		//}
	//}
	
	#endregion
}

#endregion