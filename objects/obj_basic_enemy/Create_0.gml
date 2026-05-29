////////////////////////////////
/// VARIÁVEIS DE CONTROLE /////
//////////////////////////////
#region Variáveis de controle

//Variáveis de vida
life = 5;

velh        = 0;
velv        = 0;
max_velh    = 1.5;
max_velv    = 6;
grav        = 0.3;
grav_atual  = grav;
chao        = false;
dir         = 1; //Direção em que está olhando --- 1 (Direita) / -1 (Esquerda)

//Variáveis de animação
sprite				= sprite_index;
image_numb			= image_number;
image_ind			= image_index;
image_spd			= image_speed / 3;
current_animation	= noone;
attack_done			= false;

//Variáveis do estado IDLE
idle_timer_change       = 2; //2 Segundos

//Variáveis do estado RUN
run_timer_change        = 4; //3 segundos
destiny_x               = noone;


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

dir = image_xscale;

if (velh < 0) dir  = -1;
if (velh >= 0) dir =  1;

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
    ATTACK,
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
    	case enemy_state.IDLE: state_idle(); break;
    	case enemy_state.RUN: state_run(); break;
    	case enemy_state.ATTACK: state_attack(); break;
    	case enemy_state.HURT: state_hurt(); break;
    	case enemy_state.DIE: state_die(); break;
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
    
    //Diminui o timer para trocar de estado
    if (idle_timer_change > 0) idle_timer_change -= delta_time / 1000000;
    
    //SE o timer chegar no 0, ele escolhe se fica parado ou se troca de estado
    if (idle_timer_change <= 0)
    {
        //Reseta o timer
        idle_timer_change = 2;
        state_enemy = choose(enemy_state.IDLE, enemy_state.RUN);
    }
}

state_run = function() // CORRENDO
{
    //Debug de estado
    debug_enemy_state = "Run";
    
    //Muda sprite
    change_sprites(1);
    
    //Define a velocidade da sprite
    image_spd = image_speed / 7;
}
#endregion