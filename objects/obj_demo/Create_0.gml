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

var buffer = buffer_load("shapes/obb.vbuff");
obb = vertex_create_buffer_from_buffer(buffer, vertex_format);
buffer_delete(buffer);

var buffer = buffer_load("shapes/capsule_middle.vbuff");
capsule_middle = vertex_create_buffer_from_buffer(buffer, vertex_format);
buffer_delete(buffer);

var buffer = buffer_load("shapes/capsule_end.vbuff");
capsule_end = vertex_create_buffer_from_buffer(buffer, vertex_format);
buffer_delete(buffer);

var buffer = buffer_load("meshes/tree.vbuff");
var vertex_size = 28;
tree_vertices = [];
for (var i = 0, n = buffer_get_size(buffer); i < n; i += vertex_size * 3) {
    array_push(tree_vertices, new ColTriangle(
        new Vector3(
            buffer_peek(buffer, i + 0 * vertex_size + 0, buffer_f32),
            buffer_peek(buffer, i + 0 * vertex_size + 4, buffer_f32),
            buffer_peek(buffer, i + 0 * vertex_size + 8, buffer_f32)
        ),
        new Vector3(
            buffer_peek(buffer, i + 1 * vertex_size + 0, buffer_f32),
            buffer_peek(buffer, i + 1 * vertex_size + 4, buffer_f32),
            buffer_peek(buffer, i + 1 * vertex_size + 8, buffer_f32)
        ),
        new Vector3(
            buffer_peek(buffer, i + 2 * vertex_size + 0, buffer_f32),
            buffer_peek(buffer, i + 2 * vertex_size + 4, buffer_f32),
            buffer_peek(buffer, i + 2 * vertex_size + 8, buffer_f32)
        )
    ));
}
tree = vertex_create_buffer_from_buffer(buffer, vertex_format);
buffer_delete(buffer);

var buffer = buffer_load("meshes/terrain.vbuff");
terrain = vertex_create_buffer_from_buffer(buffer, vertex_format);
buffer_delete(buffer);

terrain_heightmap = buffer_load("terrain.hm");

shape_1 = new ColTestPoint(point);
shape_2 = new ColTestPoint(point);