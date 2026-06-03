
///////////////// TODAS FUNÇÕES / FUNCTIONS DO JOGO ////////////////////////////

function tremor(_forca = 1)
{
	if (instance_exists(obj_manager))
	{
		with (obj_manager)
		{
			if (_forca > treme)
			{
				treme = _forca;
			}
		}
	}
}