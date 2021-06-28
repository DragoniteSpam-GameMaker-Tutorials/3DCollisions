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

var view_mat = matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 0, 1);
var proj_mat = matrix_build_projection_perspective_fov(-60, -window_get_width() / window_get_height(), 1, 32000);
camera_set_view_mat(camera, view_mat);
camera_set_proj_mat(camera, proj_mat);
camera_apply(camera);

vertex_submit(grid, pr_linelist, -1);

shape_1.draw();
shape_2.draw();

var mouse_vector = screen_to_world(window_mouse_get_x(), window_mouse_get_y(), view_mat, proj_mat);
var ray = new ColRay(new Vector3(xfrom, yfrom, zfrom), new Vector3(mouse_vector.x, mouse_vector.y, mouse_vector.z));
var hit_info = new RaycastHitInformation();
if (shape_1.data.CheckRay(ray, hit_info)) {
    matrix_set(matrix_world, matrix_build(hit_info.point.x, hit_info.point.y, hit_info.point.z, 0, 0, 0, 1, 1, 1));
    vertex_submit(point, pr_trianglelist, -1);
    matrix_set(matrix_world, matrix_build_identity());
}

hit_info.Clear();
if (shape_2.data.CheckRay(ray, hit_info)) {
    matrix_set(matrix_world, matrix_build(hit_info.point.x, hit_info.point.y, hit_info.point.z, 0, 0, 0, 1, 1, 1));
    vertex_submit(point, pr_trianglelist, -1);
    matrix_set(matrix_world, matrix_build_identity());
}

shader_reset();
gpu_set_zwriteenable(false);
gpu_set_ztestenable(false);
gpu_set_cullmode(cull_noculling);