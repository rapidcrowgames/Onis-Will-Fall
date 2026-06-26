
//SE está ligado o texto pós morte, ele exibe centralizado na tel
//mas um pouco mais para baixo
if (restart_death)
{
    //Pega as dimensões da tela
    var _tela_y = display_get_gui_height();
    var _tela_x = display_get_gui_width();
    
    //Configura fonte e alinhamento
    draw_set_font(fnt_death);
    draw_set_halign(1);
    draw_set_valign(1);
    
    //Desenha o texto
    draw_text(_tela_x / 2, _tela_y / 1.2, "Aperte ENTER para tentar novamente");
    
    //Reseta as configurações do texto
    draw_set_font(-1);
    draw_set_halign(-1);
    draw_set_valign(-1);
}
else {
	//Desenha na tela a quantidade de vida e tiros
    //Configura fonte e alinhamento
    draw_set_font(fnt_death);
    
    //desenha as lifes
    draw_text(20, 20, "Vidas:" + " " + string(life));
    
    //Desenha os tiros
    draw_text(20, 60, "Shots:" + " " + string(shot_item));
    
    //Reseta as configurações do texto
    draw_set_font(-1);
    draw_set_halign(-1);
    draw_set_valign(-1);

}