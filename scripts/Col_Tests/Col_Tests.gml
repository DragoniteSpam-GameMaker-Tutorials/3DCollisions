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
        return shape.data.CheckPoint(self.data);
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
        return shape.data.CheckSphere(self.data);
    };
}

function ColTestAABB(vbuff) constructor {
    self.data = new ColAABB(new Vector3(0, 0, 0), new Vector3(4, 8, 6));
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
        return shape.data.CheckAABB(self.data);
    };
}

function ColTestPlane(vbuff) constructor {
    self.data = new ColPlane(new Vector3(0, 0, 1), 0);
    self.vbuff = vbuff;
    
    self.update = function() {
        if (keyboard_check(vk_up)) {
            self.data.distance--;
        }
        if (keyboard_check(vk_down)) {
            self.data.distance++;
        }
    };
    self.draw = function() {
        matrix_set(matrix_world, matrix_build(
            0, 0, self.data.distance,
            0, 0, 0,
            1, 1, 1
        ));
        vertex_submit(self.vbuff, pr_trianglelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
    };
    self.test = function(shape) {
        return shape.data.CheckPlane(self.data);
    };
}