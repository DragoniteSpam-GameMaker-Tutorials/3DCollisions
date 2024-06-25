vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_colour();
vertex_format = vertex_format_end();

show_debug_overlay(true);

dir = 315;
pitch = -20;
dist = 200;

var buffer = buffer_load("shapes/grid.vbuff");
grid = vertex_create_buffer_from_buffer(buffer, vertex_format);
buffer_delete(buffer);

buffer = buffer_load("shapes/aabb.vbuff");
aabb = vertex_create_buffer_from_buffer(buffer, vertex_format);
buffer_delete(buffer);

buffer = buffer_load("shapes/plane.vbuff");
plane = vertex_create_buffer_from_buffer(buffer, vertex_format);
buffer_delete(buffer);

buffer = buffer_load("shapes/point.vbuff");
point = vertex_create_buffer_from_buffer(buffer, vertex_format);
buffer_delete(buffer);

buffer = buffer_load("shapes/sphere.vbuff");
sphere = vertex_create_buffer_from_buffer(buffer, vertex_format);
buffer_delete(buffer);

buffer = buffer_load("shapes/obb.vbuff");
obb = vertex_create_buffer_from_buffer(buffer, vertex_format);
buffer_delete(buffer);

buffer = buffer_load("shapes/capsule_middle.vbuff");
capsule_middle = vertex_create_buffer_from_buffer(buffer, vertex_format);
buffer_delete(buffer);

buffer = buffer_load("shapes/capsule_end.vbuff");
capsule_end = vertex_create_buffer_from_buffer(buffer, vertex_format);
buffer_delete(buffer);

buffer = buffer_load("meshes/tree.vbuff");
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

buffer = buffer_load("meshes/terrain.vbuff");
terrain = vertex_create_buffer_from_buffer(buffer, vertex_format);
buffer_delete(buffer);

terrain_heightmap = buffer_load("terrain.hm");

shape_1 = new ColTestPoint(point);
shape_2 = new ColTestPoint(point);

var test_combo = function(shape1, shape2) {
	var t0 = get_timer();
	repeat (10_000) {
		shape1.test(shape2);
	}
	var t1 = get_timer();
	show_debug_message($"{instanceof(shape1)} vs {instanceof(shape2)}, time: {(t1 - t0) / 1000} ms");
};

var p1 = new Vector3(random_range(-20, 0), random_range(-20, 0), random_range(-20, 20));
var p2 = new Vector3(random_range(-20, 20), random_range(-20, 20), random_range(-20, 20));
var p3 = new Vector3(random_range(0, 20), random_range(0, 20), random_range(-20, 20));

random_set_seed(0);

var sphere1 = new ColTestSphere(undefined);
var sphere2 = new ColTestSphere(undefined);
var aabb1 = new ColTestAABB(undefined);
var aabb2 = new ColTestAABB(undefined);
var obb1 = new ColTestOBB(undefined);
var obb2 = new ColTestOBB(undefined);
var triangle1 = new ColTestTriangle();
var triangle2 = new ColTestTriangle();
var trimesh = new ColTestMesh(self.tree);
var capsule1 = new ColTestCapsule(undefined, undefined);
var capsule2 = new ColTestCapsule(undefined, undefined);

test_combo(sphere1, sphere2);
test_combo(aabb1, aabb2);
test_combo(sphere1, aabb2);
test_combo(sphere1, obb2);
test_combo(capsule1, sphere2);
test_combo(triangle1, triangle2);

test_combo(triangle1, sphere2);
test_combo(capsule1, triangle2);
test_combo(obb1, obb2);
test_combo(aabb1, obb2);
test_combo(triangle1, trimesh);