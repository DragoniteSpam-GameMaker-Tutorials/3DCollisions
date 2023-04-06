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

function ColTestOBB(vbuff) constructor {
    var orientation = new Matrix4(matrix_build(0, 0, 0, random(360), random(360), random(360), 1, 1, 1)).GetOrientationMatrix();
    self.data = new ColOBB(new Vector3(0, 0, 0), new Vector3(irandom_range(2, 4), irandom_range(2, 4), irandom_range(2, 4)), orientation);
    self.vbuff = vbuff;
    
    self.update = function() {
        var step = 0.1;
        if (keyboard_check(vk_left)) {
            self.data.position.x -= step;
        }
        if (keyboard_check(vk_right)) {
            self.data.position.x += step;
        }
        if (keyboard_check(vk_up)) {
            self.data.position.y -= step;
        }
        if (keyboard_check(vk_down)) {
            self.data.position.y += step;
        }
        if (keyboard_check(vk_pageup)) {
            self.data.position.z -= step;
        }
        if (keyboard_check(vk_pagedown)) {
            self.data.position.z += step;
        }
    };
    self.draw = function() {
        var mat_scale = matrix_build(0, 0, 0, 0, 0, 0, self.data.size.x, self.data.size.y, self.data.size.z);
        var mat_translation = matrix_build(self.data.position.x, self.data.position.y, self.data.position.z, 0, 0, 0, 1, 1, 1);
        matrix_set(matrix_world, matrix_multiply(matrix_multiply(mat_scale, self.data.orientation.GetRotationMatrix().AsLinearArray()), mat_translation));
        vertex_submit(self.vbuff, pr_trianglelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
    };
    self.test = function(shape) {
        return shape.data.CheckOBB(self.data);
    };
}

function ColTestCapsule(vbuff_end, vbuff_middle) constructor {
    self.data = new ColCapsule(new Vector3(0, 0, -random(4) - 2), new Vector3(0, 0, random(4) + 2), random_range(1, 6));
    self.vbuff_end = vbuff_end;
    self.vbuff_middle = vbuff_middle;
    
    self.update = function() {
        var step = 0.1;
        // capsule start point - hold shift
        if (!keyboard_check(vk_control) || keyboard_check(vk_shift)) {
            if (keyboard_check(vk_left)) {
                self.data.line.start.x -= step;
            }
            if (keyboard_check(vk_right)) {
                self.data.line.start.x += step;
            }
            if (keyboard_check(vk_up)) {
                self.data.line.start.y -= step;
            }
            if (keyboard_check(vk_down)) {
                self.data.line.start.y += step;
            }
            if (keyboard_check(vk_pageup)) {
                self.data.line.start.z -= step;
            }
            if (keyboard_check(vk_pagedown)) {
                self.data.line.start.z += step;
            }
        }
        // capsule finish point - hold control
        if (keyboard_check(vk_control) || !keyboard_check(vk_shift)) {
            if (keyboard_check(vk_left)) {
                self.data.line.finish.x -= step;
            }
            if (keyboard_check(vk_right)) {
                self.data.line.finish.x += step;
            }
            if (keyboard_check(vk_up)) {
                self.data.line.finish.y -= step;
            }
            if (keyboard_check(vk_down)) {
                self.data.line.finish.y += step;
            }
            if (keyboard_check(vk_pageup)) {
                self.data.line.finish.z -= step;
            }
            if (keyboard_check(vk_pagedown)) {
                self.data.line.finish.z += step;
            }
        }
    };
    self.draw = function() {
        var vbuff = vertex_create_buffer();
        vertex_begin(vbuff, obj_demo.vertex_format);
        vertex_position_3d(vbuff, self.data.line.start.x, self.data.line.start.y, self.data.line.start.z);
        vertex_normal(vbuff, 0, 0, 1);
        vertex_colour(vbuff, c_lime, 1);
        vertex_position_3d(vbuff, self.data.line.finish.x, self.data.line.finish.y, self.data.line.finish.z);
        vertex_normal(vbuff, 0, 0, 1);
        vertex_colour(vbuff, c_lime, 1);
        vertex_end(vbuff);
        vertex_submit(vbuff, pr_linelist, -1);
        vertex_delete_buffer(vbuff);
        
        if (!keyboard_check(vk_tab)) {
            matrix_set(matrix_world, matrix_build(self.data.line.start.x, self.data.line.start.y, self.data.line.start.z, 0, 0, 0, self.data.radius, self.data.radius, self.data.radius));
            vertex_submit(self.vbuff_end, pr_trianglelist, -1);
            matrix_set(matrix_world, matrix_build(self.data.line.finish.x, self.data.line.finish.y, self.data.line.finish.z, 0, 0, 0, self.data.radius, self.data.radius, self.data.radius));
            vertex_submit(self.vbuff_end, pr_trianglelist, -1);
            matrix_set(matrix_world, matrix_build(self.data.line.finish.x, self.data.line.finish.y, mean(self.data.line.start.z, self.data.line.finish.z), 0, 0, 0, self.data.radius, self.data.radius, abs(self.data.line.start.z - self.data.line.finish.z)));
            vertex_submit(self.vbuff_middle, pr_trianglelist, -1);
            matrix_set(matrix_world, matrix_build_identity());
        }
    };
    self.test = function(shape) {
        return shape.data.CheckCapsule(self.data);
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

#macro RANDOM_POSITION  (random_range(-32, 32))
#macro RANDOM_ROTATION  (random(360))

function ColTestModel(vbuff, triangles) constructor {
    var t0 = get_timer();
    
    self.position = new Vector3(RANDOM_POSITION, RANDOM_POSITION, RANDOM_POSITION);
    self.rotation = new Vector3(RANDOM_ROTATION, RANDOM_ROTATION, RANDOM_ROTATION);
    
    var rotation_matrix = new Matrix4(matrix_build(0, 0, 0, self.rotation.x, self.rotation.y, self.rotation.z, 1, 1, 1)).GetOrientationMatrix();
    
    self.data = new ColTransformedModel(new ColMesh(triangles), self.position, rotation_matrix);
    var t1 = get_timer();
    show_debug_message("mesh setup took " + string((t1 - t0) / 1000) + " ms");
    self.vbuff = vbuff;
    
    self.update = function() {
        var step = 0.25;
        if (keyboard_check(vk_left)) {
            self.position.x -= step;
            self.data.position = self.position;
        }
        if (keyboard_check(vk_right)) {
            self.position.x += step;
            self.data.position = self.position;
        }
        if (keyboard_check(vk_up)) {
            self.position.y -= step;
            self.data.position = self.position;
        }
        if (keyboard_check(vk_down)) {
            self.position.y += step;
            self.data.position = self.position;
        }
        if (keyboard_check(vk_pageup)) {
            self.position.z += step;
            self.data.position = self.position;
        }
        if (keyboard_check(vk_pagedown)) {
            self.position.z -= step;
            self.data.position = self.position;
        }
        step = 5;
        if (keyboard_check(ord("I"))) {
            self.rotation.x -= step;
            var rotation_matrix = new Matrix4(matrix_build(0, 0, 0, self.rotation.x, self.rotation.y, self.rotation.z, 1, 1, 1)).GetOrientationMatrix();
            self.data.rotation = rotation_matrix;
        }
        if (keyboard_check(ord("J"))) {
            self.rotation.x += step;
            var rotation_matrix = new Matrix4(matrix_build(0, 0, 0, self.rotation.x, self.rotation.y, self.rotation.z, 1, 1, 1)).GetOrientationMatrix();
            self.data.rotation = rotation_matrix;
        }
        if (keyboard_check(ord("O"))) {
            self.rotation.y -= step;
            var rotation_matrix = new Matrix4(matrix_build(0, 0, 0, self.rotation.x, self.rotation.y, self.rotation.z, 1, 1, 1)).GetOrientationMatrix();
            self.data.rotation = rotation_matrix;
        }
        if (keyboard_check(ord("K"))) {
            self.rotation.y += step;
            var rotation_matrix = new Matrix4(matrix_build(0, 0, 0, self.rotation.x, self.rotation.y, self.rotation.z, 1, 1, 1)).GetOrientationMatrix();
            self.data.rotation = rotation_matrix;
        }
        if (keyboard_check(ord("P"))) {
            self.rotation.z -= step;
            var rotation_matrix = new Matrix4(matrix_build(0, 0, 0, self.rotation.x, self.rotation.y, self.rotation.z, 1, 1, 1)).GetOrientationMatrix();
            self.data.rotation = rotation_matrix;
        }
        if (keyboard_check(ord("L"))) {
            self.rotation.z += step;
            var rotation_matrix = new Matrix4(matrix_build(0, 0, 0, self.rotation.x, self.rotation.y, self.rotation.z, 1, 1, 1)).GetOrientationMatrix();
            self.data.rotation = rotation_matrix;
        }
    };
    
    self.draw = function() {
        var transform = self.data.GetTransformMatrix();
        matrix_set(matrix_world, transform.AsLinearArray());
        vertex_submit(self.vbuff, pr_trianglelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
    };
    
    self.test = function(shape) {
        return shape.data.CheckModel(self.data);
    };
}

function ColTestHeightmap(vbuff, heightmap) constructor {
    self.data = undefined;
    
    self.heightmap = new ColHeightmap(heightmap, 64, 64, 10);
    self.ball = new Vector3(0, 0, 0);
    self.vbuff = vbuff;
    
    self.update = function() {
        var step = 0.25;
        if (keyboard_check(vk_left)) {
            self.ball.x -= step;
        }
        if (keyboard_check(vk_right)) {
            self.ball.x += step;
        }
        if (keyboard_check(vk_up)) {
            self.ball.y -= step;
        }
        if (keyboard_check(vk_down)) {
            self.ball.y += step;
        }
        
        self.ball.z = self.heightmap.GetHeight(self.ball.x, self.ball.y);
    };
    
    self.draw = function() {
        matrix_set(matrix_world, matrix_build(0, 0, 0, 0, 0, 0, self.heightmap.scale, self.heightmap.scale, self.heightmap.scale));
        vertex_submit(self.vbuff, pr_trianglelist, -1);
        matrix_set(matrix_world, matrix_build(self.ball.x, self.ball.y, self.ball.z, 0, 0, 0, 1, 1, 1));
        vertex_submit(obj_demo.sphere, pr_trianglelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
    };
    
    self.test = function(shape) {
        return false;
    };
}