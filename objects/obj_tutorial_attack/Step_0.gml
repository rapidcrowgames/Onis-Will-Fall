
//SE ele não se destruiu
if (!destruir)
{
    // Fade IN
    if (alpha < 1)
        alpha = min(alpha + fade_speed, 1);
}
else
{
    // Fade OUT — quando chegar em 0, se destrói
    alpha = max(alpha - fade_speed, 0);
    if (alpha <= 0)
        instance_destroy();
}