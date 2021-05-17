draw_set_font(fnt_demo);
draw_text_colour(32, 20, "FPS: " + string(fps) + "/" + string(fps_real), 0x00ccff, 0x00ccff, 0x00ccff, 0x00ccff, 1);
draw_text_colour(32, 40, "Q: zoom in", c_white, c_white, c_white, c_white, 1);
draw_text_colour(32, 60, "E: zoom out", c_white, c_white, c_white, c_white, 1);
draw_text_colour(192, 40, "W: rotate camera up", c_white, c_white, c_white, c_white, 1);
draw_text_colour(192, 60, "S: rotate camera down", c_white, c_white, c_white, c_white, 1);
draw_text_colour(480, 40, "A: rotate camera left", c_white, c_white, c_white, c_white, 1);
draw_text_colour(480, 60, "D: rotate camera right", c_white, c_white, c_white, c_white, 1);

draw_text_colour(720, 20, "Numpad 0: Shape 1 Point", c_white, c_white, c_white, c_white, 1);
draw_text_colour(720, 40, "Numpad 1: Shape 1 Sphere", c_white, c_white, c_white, c_white, 1);
draw_text_colour(720, 60, "Numpad 2: Shape 1 AABB", c_white, c_white, c_white, c_white, 1);
draw_text_colour(720, 80, "Numpad 3: Shape 1 Plane", c_white, c_white, c_white, c_white, 1);

draw_text_colour(1080, 20, "Numpad 4: Shape 2 Point", c_white, c_white, c_white, c_white, 1);
draw_text_colour(1080, 40, "Numpad 5: Shape 2 Sphere", c_white, c_white, c_white, c_white, 1);
draw_text_colour(1080, 60, "Numpad 6: Shape 2 AABB", c_white, c_white, c_white, c_white, 1);
draw_text_colour(1080, 80, "Numpad 7: Shape 2 Plane", c_white, c_white, c_white, c_white, 1);

if (shape_2.test(shape_1)) {
    draw_text_colour(32, 100, "Shapes overlap!", c_red, c_red, c_red, c_red, 1);
}