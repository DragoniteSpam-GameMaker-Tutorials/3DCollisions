function ColMesh(triangle_array) constructor {
    self.triangles = triangle_array;
    
    self.bounds_min = new Vector3(infinity, infinity, infinity);
    self.bounds_max = new Vector3(-infinity, -infinity, -infinity);
    
    for (var i = 0; i < array_length(triangle_array); i++) {
        var tri = triangle_array[i];
        self.bounds_min.x = min(self.bounds_min.x, tri.a.x, tri.b.x, tri.c.x);
        self.bounds_min.y = min(self.bounds_min.y, tri.a.y, tri.b.y, tri.c.y);
        self.bounds_min.z = min(self.bounds_min.z, tri.a.z, tri.b.z, tri.c.z);
        self.bounds_max.x = max(self.bounds_max.x, tri.a.x, tri.b.x, tri.c.x);
        self.bounds_max.y = max(self.bounds_max.y, tri.a.y, tri.b.y, tri.c.y);
        self.bounds_max.z = max(self.bounds_max.z, tri.a.z, tri.b.z, tri.c.z);
    }
    
    self.bounds = NewColAABBFromMinMax(self.bounds_min, self.bounds_max);
    
    self.accelerator = new ColOctree(self.bounds, self);
    self.accelerator.triangles = triangle_array;
    self.accelerator.Split(3);
    
    static CheckObject = function(object) {
        return object.shape.CheckMesh(self);
    };
    
    static CheckGeneral = function(shape) {
        var process_these = [self.accelerator];
        
        while (array_length(process_these) > 0) {
            var tree = process_these[0];
            array_delete(process_these, 0, 1);
            
            if (tree.children == undefined) {
                for (var i = 0; i < array_length(tree.triangles); i++) {
                    if (shape.CheckTriangle(tree.triangles[i])) {
                        return true;
                    }
                }
            } else {
                for (var i = 0; i < 8; i++) {
                    if (shape.CheckAABB(tree.children[i].bounds)) {
                        array_push(process_these, tree.children[i]);
                    }
                }
            }
        }
        
        return false;
    };
    
    static CheckPoint = function(point) {
        return self.CheckGeneral(point);
    };
    
    static CheckSphere = function(sphere) {
        return self.CheckGeneral(sphere);
    };
    
    static CheckAABB = function(aabb) {
        return self.CheckGeneral(aabb);
    };
    
    static CheckPlane = function(plane) {
        return self.CheckGeneral(plane);
    };
    
    static CheckTriangle = function(triangle) {
        return self.CheckGeneral(triangle);
    };
    
    static CheckMesh = function(mesh) {
        return self.CheckGeneral(mesh);
    };
    
    static CheckModel = function(model) {
        return false;
    };
    
    static CheckOBB = function(obb) {
        return self.CheckGeneral(obb);
    };
    
    static CheckCapsule = function(capsule) {
        return self.CheckGeneral(capsule);
    };
    
    static CheckRay = function(ray, hit_info) {
        var process_these = [self.accelerator];
        var dummy_hit_info = new RaycastHitInformation();
        var hit_detected = false;
        
        while (array_length(process_these) > 0) {
            var tree = process_these[0];
            array_delete(process_these, 0, 1);
            
            if (tree.children == undefined) {
                for (var i = 0; i < array_length(tree.triangles); i++) {
                    if (ray.CheckTriangle(tree.triangles[i], hit_info)) {
                        hit_detected = true;
                    }
                }
            } else {
                for (var i = 0; i < 8; i++) {
                    if (ray.CheckAABB(tree.children[i].bounds, dummy_hit_info)) {
                        array_push(process_these, tree.children[i]);
                    }
                }
            }
        }
        
        return hit_detected;
    };
    
    static CheckLine = function(line) {
        var dir = line.finish.Sub(line.start).Normalize();
        var ray = new ColRay(line.start, dir);
        var hit_info = new RaycastHitInformation();
        if (self.CheckRay(ray, hit_info)) {
            return (hit_info.distance <= line.Length());
        }
        return false;
    };
    
    static GetMin = function() {
        return self.bounds_min;
    };
    
    static GetMax = function() {
        return self.bounds_max;
    };
}