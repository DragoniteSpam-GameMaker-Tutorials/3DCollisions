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

shape_1 = new ColTestPoint(point, false);
shape_2 = new ColTestPoint(point, true);