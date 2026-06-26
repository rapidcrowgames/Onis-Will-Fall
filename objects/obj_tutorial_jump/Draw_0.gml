// DRAW
draw_set_font(fnt_tutorial);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_alpha(alpha);

// DRAW
draw_set_font(fnt_tutorial);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_alpha(alpha);

draw_text_transformed_colour(
    x, y,
    texto,
    escala, escala,  // xscale, yscale
    0,               // rotação
    c_white, c_white, c_white, c_white,
    alpha
);

// Reseta o alpha depois pra não afetar outros objetos
draw_set_alpha(1);
draw_set_font(-1);
draw_set_halign(-1);
draw_set_valign(-1);
draw_set_alpha(1);