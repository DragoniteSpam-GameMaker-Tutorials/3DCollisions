draw_set_font(fnt_demo);
draw_text_colour(32, 20, "FPS: " + string(fps) + "/" + string(fps_real), 0x00ccff, 0x00ccff, 0x00ccff, 0x00ccff, 1);
draw_text_colour(32, 40, "Q: zoom in", c_white, c_white, c_white, c_white, 1);
draw_text_colour(32, 60, "E: zoom out", c_white, c_white, c_white, c_white, 1);
draw_text_colour(192, 40, "W: rotate camera up", c_white, c_white, c_white, c_white, 1);
draw_text_colour(192, 60, "S: rotate camera down", c_white, c_white, c_white, c_white, 1);
draw_text_colour(480, 40, "A: rotate camera left", c_white, c_white, c_white, c_white, 1);
draw_text_colour(480, 60, "D: rotate camera right", c_white, c_white, c_white, c_white, 1);

var n = 1;
draw_text_colour(720, n++ * 20, "Numpad 0: Shape 1 Point", c_white, c_white, c_white, c_white, 1);
draw_text_colour(720, n++ * 20, "Numpad 1: Shape 1 Sphere", c_white, c_white, c_white, c_white, 1);
draw_text_colour(720, n++ * 20, "Numpad 2: Shape 1 AABB", c_white, c_white, c_white, c_white, 1);
draw_text_colour(720, n++ * 20, "Numpad 3: Shape 1 Triangle", c_white, c_white, c_white, c_white, 1);
draw_text_colour(720, n++ * 20, "Numpad 4: Shape 1 Plane", c_white, c_white, c_white, c_white, 1);
draw_text_colour(720, n++ * 20, "Numpad 5: Shape 1 Line", c_white, c_white, c_white, c_white, 1);
draw_text_colour(720, n++ * 20, "Numpad 6: Shape 1 Mesh", c_white, c_white, c_white, c_white, 1);
draw_text_colour(720, n++ * 20, "Numpad 7: Shape 1 OBB", c_white, c_white, c_white, c_white, 1);
draw_text_colour(720, n++ * 20, "Numpad 8: Shape 1 Capsule", c_white, c_white, c_white, c_white, 1);
draw_text_colour(720, n++ * 20, "Numpad 9: Shape 1 Model", c_white, c_white, c_white, c_white, 1);

draw_text_colour(720, n++ * 20, "Tab: Terrain heightmap", c_white, c_white, c_white, c_white, 1);

n = 1;
draw_text_colour(1080, n++ * 20, "1: Shape 2 Point", c_white, c_white, c_white, c_white, 1);
draw_text_colour(1080, n++ * 20, "2: Shape 2 Sphere", c_white, c_white, c_white, c_white, 1);
draw_text_colour(1080, n++ * 20, "3: Shape 2 AABB", c_white, c_white, c_white, c_white, 1);
draw_text_colour(1080, n++ * 20, "4: Shape 2 Triangle", c_white, c_white, c_white, c_white, 1);
draw_text_colour(1080, n++ * 20, "5: Shape 2 Plane", c_white, c_white, c_white, c_white, 1);
draw_text_colour(1080, n++ * 20, "6: Shape 2 Line", c_white, c_white, c_white, c_white, 1);
draw_text_colour(1080, n++ * 20, "7: Shape 2 Mesh", c_white, c_white, c_white, c_white, 1);
draw_text_colour(1080, n++ * 20, "8: Shape 2 OBB", c_white, c_white, c_white, c_white, 1);
draw_text_colour(1080, n++ * 20, "9: Shape 2 Capsule", c_white, c_white, c_white, c_white, 1);
draw_text_colour(1080, n++ * 20, "0: Shape 2 Model", c_white, c_white, c_white, c_white, 1);

var t0 = get_timer();
var overlap = shape_2.test(shape_1);
var t1 = get_timer();
draw_text_colour(32, 100, $"Test time: {t1 - t0} microseconds", c_white, c_white, c_white, c_white, 1);
if (overlap) {
    draw_text_colour(32, 120, "Shapes overlap!", c_red, c_red, c_red, c_red, 1);
}