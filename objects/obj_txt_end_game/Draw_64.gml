
//Pego os alinhamentos
draw_set_font(fnt_death);
draw_set_halign(1);
draw_set_valign(1);

var _tela_x = display_get_gui_width() / 2;
var _tela_y = display_get_gui_height() / 4;

//desenha o texto
draw_text(_tela_x, _tela_y, "Obrigado por jogar");

//reseta
draw_set_font(-1);
draw_set_halign(-1);
draw_set_valign(-1);


