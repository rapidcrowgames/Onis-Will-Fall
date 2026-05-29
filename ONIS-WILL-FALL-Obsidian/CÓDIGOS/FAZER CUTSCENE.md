Aqui é só um lembrete de como fazer no trigger para a cutscene funcionar

Criar no obj trigger um CREATE e um STEP
```create
trigger = function()
{
	//Nada aqui pois isso vai ser editado no código de criação da instancia
	//dentro da room
}
```
```step 
//SE o player colidir comigo o trigger funciona
if (place_meeting(x, y, obj_player))
{
	trigger();
}
```


E depois no código de criação da instancia dentro da room, para fazer o player entrar no estado de cutscene, e fazer ele executar a animação de acordo como queremos fazemos assim.

cutscene_action = noone  <--- uma variável dentro do player para alterar a animação / ação na cutscene

```gml
trigger = function()
{
	with (obj_player)
	{
		//Acessa o player e define que a animação dele é parado
		cutscene_action = "idle";
		
		//Muda o estado dele para cutscene
		state = player_state.CUTSCENE;
		
		//Ativa a global cutscene
		global.cutscene = true;
	}
}
```

E no estado de cutscene do player, deixamos assim:

```gml

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
```

