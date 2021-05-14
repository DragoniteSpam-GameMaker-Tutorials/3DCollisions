draw_clear(c_black);
shader_set(shd_demo);

gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
gpu_set_cullmode(cull_counterclockwise);

var camera = camera_get_active();
var xto = 0;
var yto = 0;
var zto = 0;
var xfrom = xto + dist * dcos(dir) * dcos(pitch);
var yfrom = yto - dist * dsin(dir) * dcos(pitch);
var zfrom = zto - dist * dsin(pitch);

camera_set_view_mat(camera, matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 0, 1));
camera_set_proj_mat(camera, matrix_build_projection_perspective_fov(-60, -window_get_width() / window_get_height(), 1, 32000));
camera_apply(camera);

vertex_submit(grid, pr_linelist, -1);

shape_1.draw();
shape_2.draw();

shader_reset();
gpu_set_zwriteenable(false);
gpu_set_ztestenable(false);
gpu_set_cullmode(cull_noculling);