vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_colour();
vertex_format = vertex_format_end();

dir = 315;
pitch = -20;
dist = 200;

var buffer = buffer_load("shapes/grid.vbuff");
grid = vertex_create_buffer_from_buffer(buffer, vertex_format);
buffer_delete(buffer);

var buffer = buffer_load("shapes/aabb.vbuff");
aabb = vertex_create_buffer_from_buffer(buffer, vertex_format);
buffer_delete(buffer);

var buffer = buffer_load("shapes/plane.vbuff");
plane = vertex_create_buffer_from_buffer(buffer, vertex_format);
buffer_delete(buffer);

var buffer = buffer_load("shapes/point.vbuff");
point = vertex_create_buffer_from_buffer(buffer, vertex_format);
buffer_delete(buffer);

var buffer = buffer_load("shapes/sphere.vbuff");
sphere = vertex_create_buffer_from_buffer(buffer, vertex_format);
buffer_delete(buffer);

shape_1 = {
    data: new ColPoint(new Vector3(0, 0, 0)),
    vbuff: point,
    update: function() {
        // nothing
    },
    draw: function() {
        matrix_set(matrix_world, matrix_build(self.data.position.x, self.data.position.y, self.data.position.z, 0, 0, 0, 1, 1, 1));
        vertex_submit(self.vbuff, pr_trianglelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
    },
};

shape_2 = {
    data: new ColSphere(new Vector3(0, 0, 0), 8),
    vbuff: point,
    update: function() {
        if (keyboard_check(vk_left)) {
            self.data.position.x--;
        }
        if (keyboard_check(vk_right)) {
            self.data.position.x++;
        }
        if (keyboard_check(vk_up)) {
            self.data.position.y--;
        }
        if (keyboard_check(vk_down)) {
            self.data.position.y++;
        }
        if (keyboard_check(vk_pageup)) {
            self.data.position.z--;
        }
        if (keyboard_check(vk_pagedown)) {
            self.data.position.z++;
        }
    },
    draw: function() {
        matrix_set(matrix_world, matrix_build(self.data.position.x, self.data.position.y, self.data.position.z, 0, 0, 0, self.data.radius, self.data.radius, self.data.radius));
        vertex_submit(self.vbuff, pr_trianglelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
    },
};