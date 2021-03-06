function ColTestPoint(vbuff) constructor {
    self.data = new ColPoint(new Vector3(0, 0, 0));
    self.vbuff = vbuff;
    
    self.update = function() {
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
    };
    self.draw = function() {
        matrix_set(matrix_world, matrix_build(self.data.position.x, self.data.position.y, self.data.position.z, 0, 0, 0, 1, 1, 1));
        vertex_submit(self.vbuff, pr_trianglelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
    };
    self.test = function(shape) {
        return shape.data && shape.data.CheckPoint(self.data);
    };
}

function ColTestSphere(vbuff) constructor {
    self.data = new ColSphere(new Vector3(0, 0, 0), 8);
    self.vbuff = vbuff;
    
    self.update = function() {
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
    };
    self.draw = function() {
        matrix_set(matrix_world, matrix_build(
            self.data.position.x, self.data.position.y, self.data.position.z,
            0, 0, 0,
            self.data.radius, self.data.radius, self.data.radius
        ));
        vertex_submit(self.vbuff, pr_trianglelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
    };
    self.test = function(shape) {
        return shape.data && shape.data.CheckSphere(self.data);
    };
}

function ColTestAABB(vbuff) constructor {
    self.data = new ColAABB(new Vector3(0, 0, 0), new Vector3(irandom_range(2, 8), irandom_range(2, 8), irandom_range(2, 8)));
    self.vbuff = vbuff;
    
    self.update = function() {
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
    };
    self.draw = function() {
        matrix_set(matrix_world, matrix_build(
            self.data.position.x, self.data.position.y, self.data.position.z,
            0, 0, 0,
            self.data.half_extents.x, self.data.half_extents.y, self.data.half_extents.z
        ));
        vertex_submit(self.vbuff, pr_trianglelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
    };
    self.test = function(shape) {
        return shape.data && shape.data.CheckAABB(self.data);
    };
}

function ColTestPlane(vbuff) constructor {
    self.rotation = 0;
    self.data = new ColPlane(new Vector3(0, dsin(self.rotation), dcos(self.rotation)), 0);
    self.vbuff = vbuff;
    
    self.update = function() {
        if (keyboard_check(vk_up)) {
            self.data.distance++;
        }
        if (keyboard_check(vk_down)) {
            self.data.distance--;
        }
        
        if (keyboard_check(vk_right)) {
            self.rotation--;
            self.data.normal = new Vector3(0, dsin(self.rotation), dcos(self.rotation));
        }
        if (keyboard_check(vk_left)) {
            self.rotation++;
            self.data.normal = new Vector3(0, dsin(self.rotation), dcos(self.rotation));
        }
    };
    self.draw = function() {
        var mat1 = matrix_build(0, 0, 0, self.rotation, 0, 0, 100, 100, 100);
        matrix_set(matrix_world, matrix_multiply(mat1, matrix_build(0, self.data.distance * dsin(self.rotation), self.data.distance * dcos(self.rotation), 0, 0, 0, 1, 1, 1)));
        vertex_submit(self.vbuff, pr_trianglelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
    };
    self.test = function(shape) {
        return shape.data && shape.data.CheckPlane(self.data);
    };
}

function ColTestTriangle() constructor {
    var p1 = new Vector3(random_range(-20, 0), random_range(-20, 0), random_range(-20, 20));
    var p2 = new Vector3(random_range(-20, 20), random_range(-20, 20), random_range(-20, 20));
    var p3 = new Vector3(random_range(0, 20), random_range(0, 20), random_range(-20, 20));
    
    if (keyboard_check(vk_tab)) {
        p1.z = 0;
        p2.z = 0;
        p3.z = 0;
    }
    
    self.data = new ColTriangle(p1, p2, p3);
    var norm = self.data.GetNormal();
    var nx = norm.x;
    var ny = norm.y;
    var nz = norm.z;
    
    // this is never deleted so it's technically a memory leak, but it should
    // be fine as long as you don't try to spawn half a billion of them
    self.vbuff = vertex_create_buffer();
    vertex_begin(vbuff, obj_demo.vertex_format);
    vertex_position_3d(vbuff, p1.x, p1.y, p1.z);
    vertex_normal(vbuff, nx, ny, nz);
    vertex_colour(vbuff, 0xEC7D15, 1);
    vertex_position_3d(vbuff, p2.x, p2.y, p2.z);
    vertex_normal(vbuff, nx, ny, nz);
    vertex_colour(vbuff, 0xEC7D15, 1);
    vertex_position_3d(vbuff, p3.x, p3.y, p3.z);
    vertex_normal(vbuff, nx, ny, nz);
    vertex_colour(vbuff, 0xEC7D15, 1);
    vertex_end(vbuff);
    
    self.offset = { x: 0, y: 0, z: 0 };
    
    self.update = function() {
        if (keyboard_check(vk_left)) {
            self.data.a.x--;
            self.data.b.x--;
            self.data.c.x--;
            self.offset.x--;
        }
        if (keyboard_check(vk_right)) {
            self.data.a.x++;
            self.data.b.x++;
            self.data.c.x++;
            self.offset.x++;
        }
        if (keyboard_check(vk_up)) {
            self.data.a.y--;
            self.data.b.y--;
            self.data.c.y--;
            self.offset.y--;
        }
        if (keyboard_check(vk_down)) {
            self.data.a.y++;
            self.data.b.y++;
            self.data.c.y++;
            self.offset.y++;
        }
        if (keyboard_check(vk_pageup)) {
            self.data.a.z++;
            self.data.b.z++;
            self.data.c.z++;
            self.offset.z++;
        }
        if (keyboard_check(vk_pagedown)) {
            self.data.a.z--;
            self.data.b.z--;
            self.data.c.z--;
            self.offset.z--;
        }
    };
    self.draw = function() {
        gpu_set_cullmode(cull_noculling);
        matrix_set(matrix_world, matrix_build(self.offset.x, self.offset.y, self.offset.z, 0, 0, 0, 1, 1, 1));
        vertex_submit(self.vbuff, pr_trianglelist, -1);
        gpu_set_cullmode(cull_counterclockwise);
        matrix_set(matrix_world, matrix_build_identity());
    };
    self.test = function(shape) {
        return shape.data && shape.data.CheckTriangle(self.data);
    };
}

function ColTestLine(vbuff) constructor {
    self.rotation = random(360);
    self.data = new ColLine(
        new Vector3(100 * dcos(self.rotation), -100 * dsin(self.rotation), 0),
        new Vector3(-100 * dcos(self.rotation), 100 * dsin(self.rotation), 0)
    );
    self.offset = { x: 0, y: 0 };
    
    self.update = function() {
        if (keyboard_check(vk_left)) {
            self.offset.x--;
        }
        if (keyboard_check(vk_right)) {
            self.offset.x++;
        }
        if (keyboard_check(vk_up)) {
            self.offset.y--;
        }
        if (keyboard_check(vk_down)) {
            self.offset.y++;
        }
        if (keyboard_check(vk_pageup)) {
            self.rotation++;
        }
        if (keyboard_check(vk_pagedown)) {
            self.rotation--;
        }
        self.data.start.x = 100 * dcos(self.rotation) + self.offset.x;
        self.data.start.y = 100 * dsin(self.rotation) + self.offset.y;
        self.data.finish.x = -100 * dcos(self.rotation) + self.offset.x;
        self.data.finish.y = -100 * dsin(self.rotation) + self.offset.y;
    };
    self.draw = function() {
        var vbuff = vertex_create_buffer();
        vertex_begin(vbuff, obj_demo.vertex_format);
        vertex_position_3d(vbuff, self.data.start.x, self.data.start.y, self.data.start.z);
        vertex_normal(vbuff, 0, 0, 1);
        vertex_colour(vbuff, c_lime, 1);
        vertex_position_3d(vbuff, self.data.finish.x, self.data.finish.y, self.data.finish.z);
        vertex_normal(vbuff, 0, 0, 1);
        vertex_colour(vbuff, c_lime, 1);
        vertex_end(vbuff);
        vertex_submit(vbuff, pr_linelist, -1);
        vertex_delete_buffer(vbuff);
    };
    self.test = function(shape) {
        return shape.data && shape.data.CheckLine(self.data);
    };
}

function ColTestMesh(vbuff) constructor {
    var t_start = get_timer();
    
    var data = buffer_create_from_vertex_buffer(vbuff, buffer_fixed, 1);
    var vertex_size = 28;
    var triangle_array = array_create(buffer_get_size(data) / vertex_size / 3);
    for (var i = 0, n = array_length(triangle_array); i < n; i++) {
        triangle_array[i] = new ColTriangle(
            new Vector3(
                buffer_peek(data, i * vertex_size * 3 + 0 * vertex_size + 0, buffer_f32),
                buffer_peek(data, i * vertex_size * 3 + 0 * vertex_size + 4, buffer_f32),
                buffer_peek(data, i * vertex_size * 3 + 0 * vertex_size + 8, buffer_f32)
            ),
            new Vector3(
                buffer_peek(data, i * vertex_size * 3 + 1 * vertex_size + 0, buffer_f32),
                buffer_peek(data, i * vertex_size * 3 + 1 * vertex_size + 4, buffer_f32),
                buffer_peek(data, i * vertex_size * 3 + 1 * vertex_size + 8, buffer_f32)
            ),
            new Vector3(
                buffer_peek(data, i * vertex_size * 3 + 2 * vertex_size + 0, buffer_f32),
                buffer_peek(data, i * vertex_size * 3 + 2 * vertex_size + 4, buffer_f32),
                buffer_peek(data, i * vertex_size * 3 + 2 * vertex_size + 8, buffer_f32)
            ),
        );
    }
    buffer_delete(data);
    
    self.data = new ColMesh(triangle_array);
    self.vbuff = vbuff;
    
    self.offset = { x: 0, y: 0, z: 0 };
    
    self.update = function() {
        var dx = 0;
        var dy = 0;
        var dz = 0;
        
        if (keyboard_check(vk_left)) {
            dx--;
        }
        if (keyboard_check(vk_right)) {
            dx++;
        }
        if (keyboard_check(vk_up)) {
            dy--;
        }
        if (keyboard_check(vk_down)) {
            dy++;
        }
        if (keyboard_check(vk_pageup)) {
            dz--;
        }
        if (keyboard_check(vk_pagedown)) {
            dz++;
        }
        self.offset.x += dx;
        self.offset.y += dy;
        self.offset.z += dz;
        
        if (point_distance_3d(0, 0, 0, dx, dy, dz) > 0) {
            for (var i = 0, n = array_length(self.data.triangles); i < n; i++) {
                var tri = self.data.triangles[i];
                tri.a.x += dx;
                tri.a.y += dy;
                tri.a.z += dz;
                tri.b.x += dx;
                tri.b.y += dy;
                tri.b.z += dz;
                tri.c.x += dx;
                tri.c.y += dy;
                tri.c.z += dz;
            }
        }
    };
    
    self.draw = function() {
        matrix_set(matrix_world, matrix_build(self.offset.x, self.offset.y, self.offset.z, 0, 0, 0, 1, 1, 1));
        vertex_submit(self.vbuff, pr_trianglelist, -1);
        if (keyboard_check(vk_tab)) {
            self.data.accelerator.DebugDraw();
        }
        matrix_set(matrix_world, matrix_build_identity());
    };
    
    self.test = function(shape) {
        return shape.data.CheckMesh(self.data);
    };
    
    var t_end = get_timer();
    show_debug_message("mesh setup took " + string((t_end - t_start) / 1000) + " ms");
}