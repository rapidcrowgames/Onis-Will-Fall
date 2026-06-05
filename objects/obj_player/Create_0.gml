
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
hurt = false; //Identifica se sofreu dano ou não

//Variáveis do estado de ATTACK
create_hitbox	     = false; //Cria a hitbox
combo_count          = 0;
double_parry         = false; //identifica se ambos atacaram no mesmo momento

//Variáveis do estado HURT / machucado
hurt_invencible		 = false;
hurt_timer			 = 1 // 1 segundos
attacker             = noone; //Variável que salva quem foi que me atacou

//Variável do estado de CUTSCENE
cutscene_action      = noone; //Define qual ação do SWITCH da cutscene

//Variáveis do estado de parry
parry_timer          = 0.5;
parry                = false;

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
	[spr_player_attack], //animação atacando - 2
	[spr_player_parry], //animação defesa - 3
	[spr_player_hurt], //animação machucado - 4
    
    //Novas animações [Pulo, queda, ataque 1 e 2, Parede]
    [spr_player_jump], //Animação de pulo (subida) - 5
    [spr_player_fall] //Animação de pulo (queda) - 6
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
        
	//Pega os inputs SE não estiver no hitstop
	get_inputs();
	
	//Movimento horizontal
	velh = (input_right - input_left) * max_velh;
	
	//Aplica a gravidade
	velv += grav_atual;
	
	//Calcula a direção
	if (velh > 0) dir =  1;
	if (velh < 0) dir = -1;
	
	//Aplica a direção
	image_xscale = dir;
	
	//Identifica se está ou não no chão		   //Está no chão	 //Não está no chão
	if (place_meeting(x, y + 1, obj_colisao))  {chao = true;} else {chao = false;}
	
    //Identifica se está ou não na parede            //Está na parede      //Não está na parede
    if (place_meeting(x + sign(dir), y, obj_colisao))  {parede = true;} else {parede = false;}
	
	
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
    }
    
    #endregion
	
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
		case player_state.IDLE:       state_idle();       break; //estado parado	
		case player_state.RUN:        state_run();        break; //estado correndo / se movendo
		case player_state.JUMP:       state_jump();       break; //estado de pulo
		case player_state.HURT:       state_hurt();       break; //estado sofrendo dano	
		case player_state.ATTACK:     state_attack();     break; //estado atacando	
		case player_state.PARRY:      state_parry();      break; //estado atacando	
		case player_state.DEATH:      state_death();      break; //estado de morte
		case player_state.CUTSCENE:   state_cutscene();   break; //estado de cutscene
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
	
	//Se ele sofrer dano, vai para o estado de HURT
	if (hurt) 
    {
        global.hitstop = true;
        state = player_state.HURT;
    }
    
    //SE apertar o botão do parry, ele vai para PARRY
    if (input_parry) state = player_state.PARRY;
	
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
    if (input_parry) state = player_state.PARRY;
	
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
        change_sprites_once(5)
    }
    
    //Quando já estiver mais alto e em queda, muda para sprite de queda
    if (!is_jumping)
    {
        change_sprites(6);
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
    image_spd = image_speed / 3;
    
	//Roda animação apenas uma vez
    change_sprites_once(2);
    
    // Pega o frame atual como inteiro
    var _frame = floor(image_ind);
    
    // Cria a hitbox no frame ativo (ex: frame 2 da animação)
    if (_frame == 3 && !create_hitbox) 
	{
        instance_create_layer(x + 6 * dir, y - sprite_height, layer, obj_player_hitbox);
        create_hitbox = true; // flag: "já foi criada"
    }
    
    // Destrói a hitbox quando sair do frame ativo
    if (_frame > 3 && create_hitbox) 
	{
        instance_destroy(obj_player_hitbox);
        create_hitbox = false;
    }
    
    // Animação terminou, volta pro estado certo
    if (image_ind >= sprite_get_number(sprite) - 1) 
	{
        // Garante que a hitbox some se ainda existir
        if (create_hitbox) 
		{
            instance_destroy(obj_player_hitbox);
            create_hitbox = false;
        }
		
        attack_done = true;
    }
    
    if (attack_done) 
	{
        attack_done = false;
        state = player_state.IDLE; //Volta para o estado parado
    }
}

state_hurt = function() //Estado MACHUCADO / HURT
{
    //Debug do estado
    debug_state = "Hurt";
    
    //Velocidade da animação
    image_spd = image_speed / 6;
    
    //Altera para animação 1 vez para de machucado
    change_sprites_once(4);
    
    //Perde vida e joga para trás apenas UMA VEZ (quando não é invencivel ainda)
    if (!hurt_invencible)
    {
        if (double_parry or parry) 
        {
            hurt = false;
            return;
        }
        
        //treme a tela
        tremor(4);
        
        //Perde vida SE não estão em parry duplo
        life--;
        
        //Joga o player para trás
        if (dir == -1)  velh += 35; //Joga ele para direita
        if (dir ==  1)  velh -= 35; //Joga ele para esquerda
        
        //Fica invencivel e opaco
        hurt_invencible = true;
        image_alpha = 0.5;
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
    change_sprites_once(3);
    
    //Fica parado
    velh = 0;
    
    //Define a velocidade da animação
    image_spd = image_speed / 6;
    
    //Pega os frames da imagem
    var _frame = floor(image_ind);
    
    //A partir do frame 2 que abre a janela de parry
    if (_frame >= 3 && !parry)
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
                if (dir == -1) velh += 40;
                if (dir ==  1) velh -= 40;
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
    
    //Alterar para animação de morte apenas uma vez
    //Colocar aqui quando tiver
    
    //Define a velocidade da sprite
    image_spd = image_speed / 5;
    
    //Reseta o jogo
    game_restart();
    
    //Mas aqui fazer diferente a tela de morte, levando a uma room só para isso
    //com uma animação especifica
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