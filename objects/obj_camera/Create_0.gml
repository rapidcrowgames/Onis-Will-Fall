

////////////////////////////
// VARIÁVEIS DE CONTROLE //
//////////////////////////
#region	Variáveis de controle

follow		= false; //Controla se está seguindo ou parado
target		= noone; //O alvo no qual está seguindo
debug_state = ""; //Debuga o estado atual da câmera
state		= noone; //Estado atual da câmera

vel_cam		= 0; //Define a velocidade da câmera em Cutscene

#endregion

show_message("criou")

//////////////////////////
// ENUM E STATE MACHINE //
/////////////////////////
#region Enum e Máquina de estadods

//Enum
enum cam_state
{
	PLAYER,
	CUTSCENE
}

//State machine / Máquina de estados
switch (state)
{
	case cam_state.PLAYER: follow_player(); break;	
	case cam_state.CUTSCENE: follow_cutscene(); break;	
}

//Estado inicial e atual
state = cam_state.PLAYER;

#endregion


////////////////////////
// MÉTODOS DA CÂMERA //
///////////////////////
#region	//métodos

follow_player = function()
{
	//Debug de estado
	debug_state = "player";
	
	//verifica se o player existe
	if (instance_exists(obj_player))
	{
		var _player = obj_player;
		
		//Define o player como o alvo
		target = _player;
		
		//Faz a câmera sempre seguir o player com um movimento suave
		//SE for decidido que ele está seguindo
		if (target == _player && follow)
		{
			x = lerp(x, _player.x, 0.08);
			y = lerp(y, _player.y, 0.08);
		}
	}
}

follow_cutscene = function()
{
	//Debug de estado em cutscene
	debug_state = "cutscene";
}


#endregion