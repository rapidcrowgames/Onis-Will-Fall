/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor

//////////////////////////////////
// CONTROLE DE FISÍCA E COLISÃO
// PIXEL PERFECT ////////////////
/////////////////////////////////

#region

//Colisão horizontal
var _velh = sign(velh);

//Laço de repetição
repeat(abs(velh))
{
	//Checando com até um pixel de distância do objeto
	if (place_meeting(x + _velh, y, obj_colisao))
	{
		//Se eu colidir, eu paro
		velh = 0;
		
		//Saio do laço
		break;
	}
	else
	{
		//Se ainda não colidi, então me movo 1 pixel por vez.
		if (!global.hitstop) x += _velh;	
	}
}

//Colisão vertical
var _velv = sign(velv);

//Laço de repetição 
repeat(abs(velv)) 
{
	//Checando até 1 pixel de distância do objeto
	if (place_meeting(x, y + _velv, obj_colisao))
	{
		//Se eu colidir, então eu paro de cair
		velv = 0;
		
		//Saio do laço
		break;
	}
	else
	{
		//Se ainda não colidi, então me movo um pixel por vez
		if (!global.hitstop) y += _velv;
	}
}

#endregion