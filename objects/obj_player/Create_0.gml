
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
chao		         = false;
parede               = false;
is_jumping           = false; //Verifica se estou pulando
dir			         = 1 // 1 - Direita / -1 Esquerda

//Variáveis de estados
hurt                 = false; //Identifica se sofreu dano ou não
esquive_force        = 20; //Força da esquiva

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
parry_timer          = 0.6;
p_timer              = parry_timer
parry                = false;

//Variáveis do estado DEATH
player_dead          = false;
restart_death        = false; //Variável que cuida do texto para dar restart game

//Variáveis do estado de WALL / Wall jump
wall_right           = false;
wall_left            = false;

//Variáveis do estado SHOT / Arremessáveis
shot_item            = 5; //Qtd de arremessáveis
shot_created         = false;

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
#region	Variáveis de Inputs TECLADO e CONTROLES

get_inputs = function()
{
    /// ---------- TECLADO ----------
    var _kb_right    = keyboard_check(ord("D")) or keyboard_check(vk_right);
    var _kb_left     = keyboard_check(ord("A")) or keyboard_check(vk_left);
    var _kb_jump     = keyboard_check(ord("W")) or keyboard_check(vk_space);
    var _kb_attack   = keyboard_check_pressed(ord("J")) or keyboard_check_pressed(ord("Z"));
    var _kb_parry    = keyboard_check_pressed(ord("K")) or keyboard_check_pressed(ord("X"));
    var _kb_esquive  = keyboard_check_pressed(vk_shift);
    var _kb_shot     = keyboard_check_pressed(ord("L")) or keyboard_check_pressed(ord("C"));
    
    /// ---------- GAMEPAD ----------
    var _gp_right = false, _gp_left = false, _gp_jump = false;
    var _gp_attack = false, _gp_parry = false, _gp_esquive = false;
    var _gp_shot = false;
    
    if (global.gamepad && global.gamepad_id != -1)
    {
        // ============================
        // DEADZONE DO ANALÓGICO
        // ============================
        // Valor entre 0 e 1. 0.2 é um padrão seguro (analógicos
        // raramente ficam 100% travados no centro).
        var _deadzone = 0.2;
        
        // Eixo horizontal do analógico esquerdo
        var _axis_h = gamepad_axis_value(global.gamepad_id, gp_axislh);
        if (abs(_axis_h) < _deadzone) _axis_h = 0;
        
        // Movimento -> somente analógico esquerdo, como pedido
        _gp_right = (_axis_h > 0);
        _gp_left  = (_axis_h < 0);
        
        // Pulo -> X (PS4/PS5) / A (Xbox)
        _gp_jump = gamepad_button_check(global.gamepad_id, gp_face1);
        
        // Ataque -> Quadrado (PS4/PS5) / X (Xbox)
        _gp_attack = gamepad_button_check_pressed(global.gamepad_id, gp_face3);
        
        // Parry -> L1 (PS4/PS5) / LB (Xbox)
        _gp_parry = gamepad_button_check_pressed(global.gamepad_id, gp_shoulderl);
        
        // Shot / arremesável -> Bola (PS4/PS5) / B (Xbox)
        _gp_shot = gamepad_button_check_pressed(global.gamepad_id, gp_face2);
        
        // Esquiva -> R2 (PS4/PS5) / RT (Xbox)
        _gp_esquive = gamepad_button_check_pressed(global.gamepad_id, gp_shoulderrb);
        
        #region //Dica para como adicionar mais botões no futuro.
        // ====================================================================
        // COMO ADICIONAR NOVOS BOTÕES NO FUTURO (cura, ataque à distância, etc)
        // ====================================================================
        //
        // Passo 1: lá em cima, junto com as outras "var _gp_...",
        // declare a nova variável. Exemplo para um botão de CURA:
        //
        //     var _gp_heal = false;
        //
        // Passo 2: aqui dentro do "if (global.gamepad...)", adicione a
        // leitura do botão do controle. Exemplo usando o Triângulo (PS) / Y (Xbox):
        //
        //     // Cura -> Triângulo (PS4/PS5) / Y (Xbox)
        //     _gp_heal = gamepad_button_check_pressed(global.gamepad_id, gp_face4);
        //
        // Passo 3: lá embaixo, na seção "TECLADO", crie a tecla equivalente:
        //
        //     var _kb_heal = keyboard_check_pressed(ord("Q"));
        //
        // Passo 4: na seção "COMBINA OS DOIS" (no final desta function),
        // junte os dois:
        //
        //     input_heal = _kb_heal or _gp_heal;
        //
        // Pronto! Repita esse mesmo padrão para o ataque à distância,
        // por exemplo usando R1/RB (gp_shoulderr) ou Círculo/B (gp_face2),
        // dependendo do que ainda estiver "livre" no seu mapeamento.
        // ====================================================================
        #endregion
    }
    
    /// ---------- COMBINA OS DOIS ----------
    input_right   = _kb_right   or _gp_right;
    input_left    = _kb_left    or _gp_left;
    input_jump    = _kb_jump    or _gp_jump;
    input_attack  = _kb_attack  or _gp_attack;
    input_parry   = _kb_parry   or _gp_parry;
    input_esquive = _kb_esquive or _gp_esquive;
    input_shot    = _kb_shot    or _gp_shot;
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
    [spr_player_esquive], //Animação de esquiva - 10
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
	DEATH, //Estado de morte
	ESQUIVE, //Estado de esquiva
    SHOT,   //Estado de atirar arremesável 
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
		case player_state.SHOT:                state_shot();        break; //estado de atirar arremesável
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
        
    //Se apertar o botão do shot e tiver itens para arremessar, ele vai para o SHOT
    if (input_shot && shot_item > 0) state = player_state.SHOT;
	
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
    
    //SE cair de uma plataforma enquanto corre, vai para o estado de jump (caindo)
    if (!chao && !is_jumping) state = player_state.JUMP;
	
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
        
    //Se apertar o botão do shot e tiver itens para arremessar, ele vai para o SHOT
    if (input_shot && shot_item > 0) state = player_state.SHOT;
	
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
        
    //Se apertar o botão do shot e tiver itens para arremessar, ele vai para o SHOT
    if (input_shot && shot_item > 0) state = player_state.SHOT;
	
}

state_attack = function() //Estado ATAQUE / ATTACK
{
    //Debug de estado
    state_debug = "attack";
    
    //Velocidade da animação
    image_spd = image_speed / 3.5;
    
    //Se apertar o botão do shot e tiver itens para arremessar, ele vai para o SHOT
    if (input_shot && shot_item > 0) state = player_state.SHOT;
    
    //SE for atacado durante o meu ataque, ele garante que vai destruir a hitbox
    if (hurt)
    {
        //Destrói a hitbox se ainda existir
        if (create_hitbox)
        {
            instance_destroy(obj_player_hitbox);
            create_hitbox = false;
        }
        
        global.hitstop = true;
        state = player_state.HURT;
        return;
    }
    
    //SE apertar o botão do parry, ele vai para PARRY
    if (input_parry) state = player_state.PARRY;
    
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
    state_debug = "Hurt";
    
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
    
    //A partir do frame 6 que abre a janela de parry
    if (_frame >= 6 && !parry)
    {
        parry = true;
    }
    
    //SE estou na janela de parry, conta o tempo dela
    if (parry)
    {
        if (p_timer > 0) p_timer -= delta_time / 1000000;
    }
    
    //Checa SEMPRE (dentro ou fora da janela) se fui atingido pela hitbox do inimigo
    var _hitbox = instance_place(x, y, obj_hitbox_enemy);
    if (_hitbox != noone)
    {
        //SE estou dentro da janela de parry E ainda há tempo, é um PARRY VÁLIDO
        if (parry && p_timer > 0)
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
            p_timer = parry_timer;
        }
        else
        {
            //ERREI O TIMING (ou janela já fechada) - corta a animação e vai para o dano IMEDIATAMENTE
            parry = false;        // garante reset
            p_timer = parry_timer;    // garante reset
            state = player_state.HURT;
            return; //sai do estado agora, não processa o resto do parry neste frame
        }
    }
    
    //SE o tempo esgotar sem parry, fecha a janela
    if (p_timer <= 0)
    {
        p_timer = parry_timer;
        parry = false;
    }
    
    //No fim da animação volta para IDLE
    if (image_ind >= sprite_get_number(sprite) - 1)
    {
        parry = false;        // garante reset
        p_timer = parry_timer;    // garante reset
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
        hurt_timer = 1; //Reseta o timer de dano
        state = player_state.IDLE; //Volta para o estado parado
    }
}

state_shot = function() //Estado de ARREMESÁVEL // SHOT
{
    //Debuga o estado
    state_debug = "Shot";
    
    //Escolhe a animação (Quando tiver)
    
    //Define a velocidade da animação
    image_spd = image_speed / 4;
    
    //Cria a hitbox no player de acordo com a direção dele SE ela ainda não existe
    if (!instance_exists(obj_player_hitbox_shot))
    {
        var _shot = instance_create_layer(x + 2 * dir, y - sprite_height + 10, layer, obj_player_hitbox_shot);
        _shot.direction = point_direction(0,0,dir,0);
        _shot.speed = 20;
    }
    else {
    	
        //Gasto um tiro
        if (shot_item > 0) shot_item--;
        shot_created = true;
    }
    
    //SE já criou o tiro
    if (shot_created)
    {
        shot_created = false;
        //Após criar o arremessável, eu saio do estado
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
	state_debug = "cutscene";
	
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